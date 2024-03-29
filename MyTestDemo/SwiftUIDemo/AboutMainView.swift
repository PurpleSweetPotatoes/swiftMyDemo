//
//  SwiftUIView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/1/6.
//  Copyright © 2024 Garmin All rights reserved
//  

import SwiftUI

enum SwiftUIType: CaseIterable, Identifiable {
    case test

    var name: String {
        switch self {
        case .test: return "TestDemo"
        }
    }

    var targetView: some View {
        Group {
            switch self {
            case .test: SwiftUITestView()
            }
        }
        .navigationBarBackButtonHidden()
    }

    var id: String { name }
}

struct AboutMainView: View {
    let modelList = SwiftUIType.allCases

    var body: some View {
        VStack {
            List {
                ForEach(modelList) { model in
                    NavigationLink(model.name, destination: model.targetView)
                }
            }
        }
    }
}

