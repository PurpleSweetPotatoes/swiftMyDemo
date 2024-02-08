//
//  SwiftUIView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/13.
//  Copyright © 2023 Garmin All rights reserved
//  

import SwiftUI
import BQSwiftKit

struct DoughnutData: DoughnutViewData {
    var lineWidth: CGFloat {
        10
    }

    var progress: CGFloat {
        0.55
    }

    var emptyColor: Color {
        .gray
    }

    var progressColor: Color {
        .green
    }
}

struct SwiftUIView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Top Text")
                .frame(width: 300, height: 60)
                .background(Color.cyan)
            Text("Cetner")
            ScrollView(.vertical) {
                ForEach(0..<30) { index in
                    Text("\(index)")
                }
            }
            .refresh(offsetHandle: { offset in
                print("-=-= offset \(offset)")
            }, handle: {
                print("blow iOS 16")
                await testload()
            })
//            .refreshable {
//                print("iOS 16")
//                await testload()
//            }
            .background(Color.cyan)
        }
    }

    func testload() async {
        print("-=-=-= 刷新")
        do {
            try? await Task.sleep(nanoseconds: 2000_000_000)
        }
        print("-=-=-= 完成")
    }
}

extension ScrollView {
    func refresh(offsetHandle:@escaping (CGFloat) -> Void, handle:@escaping () async -> Void)  -> some View {
        if #available(iOS 16, *) {
            return RefreshScrollView {
                content
            } offsetChanged: { offset in
                offsetHandle(offset)
            } onRefresh: {
                await handle()
            }
        } else {
            return RefreshScrollView {
                content
            } offsetChanged: { offset in
                offsetHandle(offset)
            } onRefresh: {
                await handle()
            }
        }
    }
}

struct OffsetReader: View {
    var onChange: (CGFloat) -> ()
    @State private var frame = CGRect()
    @State private var initalOffset: CGFloat?

    public var body: some View {
        
        GeometryReader { geometry in
            Spacer(minLength: 0)
                .onChange(of: geometry.frame(in: .global)) { value in
                    if value.integral != self.frame.integral {
                        self.frame = value
                        if let initalOffset = initalOffset {
                            onChange(value.minY - initalOffset)
                        } else {
                            initalOffset = value.minY
                        }
                    }
                }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
