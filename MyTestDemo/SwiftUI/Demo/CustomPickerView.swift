//
//  CustomPickerView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/4/3.
//  Copyright © 2023 Garmin All rights reserved
//  

import SwiftUI
import BQSwiftKit
struct CustomPickerView: View {
    var dataList = [0,1,2,3,4,5,6,7,8]
    var center: Int = 4
    var body: some View {
        Text("aaa")
    }

    func getDegrees(by index: Int) -> Double {
        return 90 - Double(index) * 22.5
    }
}

struct BQExample1: View {
    @State var rotateChanged: Bool = false
    @State var colorChanged: Bool = false
    @State var scaleChanged: Bool = false
    @State var offsetChanged: Bool = false
    var body: some View {
        VStack {
            Text( "I can do Animation")
                .foregroundColor(.white)
                .padding(20)
                .background(colorChanged ? Color.blue : Color.green)
                .animation(.easeInOut(duration: 0.5), value: colorChanged)
                .rotationEffect(.degrees(rotateChanged ? 180 : 0))
                .animation(.easeInOut(duration: 1), value: rotateChanged)
//                .scaleEffect(scaleChanged ? 2 : 1)
//                .animation(.easeInOut(duration: 4), value: scaleChanged)
                .offset(x: offsetChanged ? 120 : -120)
                .animation(.easeInOut(duration: 3), value: offsetChanged)
            Button {
                rotateChanged.toggle()
                colorChanged.toggle()
                scaleChanged.toggle()
                offsetChanged.toggle()
            } label: {
                Text("start animation")
            }
        }
    }
}

struct CustomPickerView_Previews: PreviewProvider {
    static var previews: some View {
        BQExample1()
    }
}
