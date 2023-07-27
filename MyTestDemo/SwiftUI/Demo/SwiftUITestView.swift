//
//  SwiftUITestView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/6/1.
//  Copyright © 2023 Garmin All rights reserved
//  

import SwiftUI
import BQSwiftKit

struct SwiftUITestView: View {
    @State var selectIndex: Int = 0
    let Colors: [Color] = [.red, .cyan, .green]
    var body: some View {
        VStack {
            HStack {
                Button {
                    selectIndex -= 1
                } label: {
                    Text("back")
                }.disabled(selectIndex == -1)

                Text("current: \(selectIndex)")

                Button {
                    selectIndex += 1
                } label: {
                    Text("forward")
                }.disabled(selectIndex == 1)
            }
            BQTabView(selectIndex: $selectIndex) {
                ForEach(0..<3) { index in
                    ScrollView(showsIndicators: false) {
                        ForEach(0..<20) { row in
                            Text("\(index) + \(row)")
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(
                        Colors[index]
                    )
                }
            }
        }
        .onChange(of: selectIndex) { newValue in
            print("selected Index: \(newValue)")
        }
//        RefreshScrollView {
//            VStack {
//                ForEach(0..<30) { index in
//                    Text("\(index)")
//                        .frame(width: 300)
//                }
//            }
//        }
//        offsetChanged: { offsetY in
//            print("current offsetY: \(offsetY)")
//        }
//        onRefresh: {
//            await loadTest()
//        }
    }

    func loadTest() async {
        print("-=-=-= 刷新")
        do {
            try? await Task.sleep(nanoseconds: 1_000_000_000 * 2)
        }
        print("-=-=-= 完成")
    }
}

struct SwiftUITestView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUITestView()
    }
}
