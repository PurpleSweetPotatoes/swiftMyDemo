//
//  TestTabView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/8/27.
//  Copyright © 2024 Garmin All rights reserved
//  

import SwiftUI

struct BQTabView: View {
    var body: some View {
        Text("")
    }
}

struct TestTabView: View {
    @State var index: Int = 0
    var buttonTitles = [0, 1, 2]
    var color: Color {
       Color(uiColor: UIColor.randomColor)
    }
    func listView(index: Int) -> some View {
        if #available(iOS 16.0, *) {
            return VStack {
                List {
                    ForEach(0..<38) {
                        Text("\(index) - \($0)")
                    }
                }
                .frame(width: 375)
            }
            .tag(index)
            .toolbar(.hidden, for: .tabBar)
            .background(color)

        } else {
            return EmptyView()
        }
    }

    var body: some View {
//        SimultaneousGestureExample()
        if #available(iOS 16.0, *) {
            VStack {
                HStack {
                    ForEach(0..<buttonTitles.indices.count) { index in
                        Button {
                            self.index = index
                        } label: {
                            Text("Tab \(index)")
                        }
                    }
                }

                TabView(selection: $index) {
                    listView(index: 0)
                    listView(index: 1)
                    listView(index: 2)
                }
                .background(.cyan)
                .ignoresSafeArea()
            }

        } else {
            // Fallback on earlier versions
        }
    }
}


struct SimultaneousGestureExample: View {
    @State private var message = "Message"
    let newGesture = TapGesture().onEnded {
        print("!!! Gesture on VStack.")
    }

    var body: some View {
        VStack(spacing:25) {
            Image(systemName: "heart.fill")
                .resizable()
                .frame(width: 75, height: 75)
                .padding()
                .foregroundColor(.red)
                .onTapGesture {
                    print("!!! Gesture on image.")
                }
            Rectangle()
                .fill(Color.blue)
        }
        .gesture(newGesture)
        .frame(width: 200, height: 200)
        .border(Color.purple)
    }

    // simultaneousGesture
    // !!! Gesture on VStack.
    // !!! Gesture on image.

    // highPriorityGesture
    // !!! Gesture on VStack.

    // gesture
    // !!! Gesture on image.
}


struct VerticalDragGesture: Gesture {
    private let minimumDistance: CGFloat
    private let coordinateSpace: CoordinateSpace

    init(minimumDistance: CGFloat = 10, coordinateSpace: CoordinateSpace = .local) {
            self.minimumDistance = minimumDistance
            self.coordinateSpace = coordinateSpace
    }

    var body: some Gesture {
        AnyGesture(
            DragGesture(minimumDistance: minimumDistance, coordinateSpace: coordinateSpace).map { value in
                if abs(value.translation.width) > abs(value.translation.height) {
                    print("!!! 横向")
                    return value
                }
                print("!!! 竖向")
                return value
            }
        )
    }
}
