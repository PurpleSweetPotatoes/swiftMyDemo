//
//  SwiftUITestView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/1/6.
//  Copyright © 2024 Garmin All rights reserved
//  

import SwiftUI

struct SwiftUITestView: View {
    @State private var message = ""
    @State private var wordCount = 0
    @FocusState var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack() {
                Button(action: {
                    isFocused = true
                }, label: {
                    Text("Button")
                })
                Spacer()
                ZStack(alignment: .bottomTrailing) {
                    // 多行文本框
                    TextEditor(text: $message)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 8)
                        .focused($isFocused)
                        .onChange(of: message) { _ in
                            if message.contains("@456") {
                                let newStr = message.replacingOccurrences(of: "@456", with: "456")
                                message = newStr
                            }
                            self.wordCount = message.count
                        }
                    // 字数统计
                    Text("\(wordCount)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(8)
                }
                //边框
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                // 注释文字
                if message.isEmpty {
                    Text("请输入内容")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .padding(8)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
