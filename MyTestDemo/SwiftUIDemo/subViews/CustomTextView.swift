//
//  CustomTextView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/8/1.
//  Copyright © 2024 Garmin All rights reserved
//  

import SwiftUI

struct CustomTextView: View {
    @State private var text: String = ""
    @State private var height: CGFloat = 40

    var body: some View {
        VStack {
            TextEditor(text: Binding(
                get: {
                    text
                },
                set: { newValue in
                    // 自定义规则：将 "@12" 替换为 "12"
                    text = newValue.replacingOccurrences(of: "@12", with: "12")
                    self.calculateHeight() // 重新计算高度
                }
            ))
            .frame(minHeight: height, maxHeight: height)
            .background(GeometryReader { geometry in
                Color.clear.onAppear {
                    calculateHeight() // 初始化时计算高度
                }
            })
            .padding(4)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            .padding()

            Spacer()
        }
    }

    // 计算 TextEditor 内容的高度
    private func calculateHeight() {
        let size = text.boundingRect(
            with: CGSize(width: UIScreen.main.bounds.width - 32, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 18)],
            context: nil
        ).size

        // 更新高度
        height = max(size.height + 16, 40) // 16 为填充和边框所需的空间
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextView()
    }
}

