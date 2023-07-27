//
//  BQBannerView.swift
//  MyTestDemo
//
//  Created by baiqiang on 2023/6/10.
//

import SwiftUI
import Combine

struct BQBannerView<Content: View, T>: View {
    let datas: [T]
    let horizontalPadding: CGFloat
    let timerInterval: CGFloat?
    let content: (T) -> Content
    var loopDatas: [T] {
        return [datas.last!] + datas + [datas.first!]
    }
    @State var dragOffset: CGFloat = .zero

    /// 当前显示的位置索引
    @State var currentIndex: Int = 1

    @State var animationType: Animation?

    @State private var cancellable: AnyCancellable?

    init(datas: [T], horizontalPadding: CGFloat = 0, timerInterval: CGFloat? = nil, @ViewBuilder content: @escaping (T) -> Content) {
        self.datas = datas
        self.timerInterval = timerInterval
        self.horizontalPadding = horizontalPadding
        self.content = content
    }

    var body: some View {
        let width = UIScreen.main.bounds.width
        let currentOffset = CGFloat(currentIndex) * width
        HStack(alignment: .center, spacing: 0) {
            ForEach(Array(loopDatas.enumerated()), id: \.0) { index, data in
                content(data)
            }
        }
        .frame(width: width, alignment: .leading)
        .offset(x: dragOffset - currentOffset)
        .gesture(dragGesture)
        .animation(animationType, value: currentIndex)
        .onAppear {
            startTimer()
        }
    }

    private func startTimer() {
        guard let timerInterval = timerInterval,
              timerInterval > 0 else {
            return
        }
        stopTimer()
        cancellable = Timer.publish(every: timerInterval, on: .main, in: .common).autoconnect().sink { _ in
            timerMoidfy()
        }
    }

    private func stopTimer() {
        cancellable?.cancel()
    }

    private func timerMoidfy() {
        animationType = .linear
        currentIndex = (currentIndex + 1) % loopDatas.count
        resetOffset()
    }

    private func resetOffset() {
        if currentIndex == loopDatas.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animationType = .none
                currentIndex = 1
            }
        } else if currentIndex == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animationType = .none
                currentIndex = loopDatas.count - 2
            }
        }
    }
}

extension BQBannerView {
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { changeValue in
                stopTimer()
                animationType = .none
                dragOffset = changeValue.translation.width
            }
            .onEnded { endValue in
                animationType = .spring()
                dragOffset = .zero

                /// 拖动右滑，偏移量增加，显示 index 减少
                if endValue.translation.width > 50 {
                    currentIndex -= 1
                }
                /// 拖动左滑，偏移量减少，显示 index 增加
                if endValue.translation.width < -50 {
                    currentIndex += 1
                }
                /// 防止越界
                currentIndex = max(min(currentIndex, loopDatas.count - 1), 0)
                resetOffset()
                startTimer()
            }
    }
}

struct Banner_Test: View {
    let colors: [Color] = [.red, .blue, .green, .pink, .purple]
    @State var currentIndex: Int = 0
    var body: some View {
        VStack {
            Text("click \(currentIndex)")
            BQBannerView(datas: colors) { color in
                ScrollView(showsIndicators: false) {
                    ForEach(0..<50) { index in
                        Text("\(index)")
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }.frame(width: UIScreen.main.bounds.width, height: .infinity)
                .background(color)
            }
            Spacer()
        }
    }
}

struct BQBannerView_Previews: PreviewProvider {
    static var previews: some View {
        Banner_Test()
    }
}
