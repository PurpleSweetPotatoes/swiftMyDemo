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
    case customText
    case testTabView
    case activityStatsView

    var name: String {
        switch self {
        case .test: return "TestDemo"
        case .customText: return "CustomTextView"
        case .testTabView: return "TestTabView"
        case .activityStatsView: return "ActivityStatsView"
        }
    }

    var targetView: some View {
        Group {
            switch self {
            case .test: TestView()
            case .customText: CustomTextView()
            case .testTabView: TestTabView()
            case .activityStatsView: ActivityStatsView()
            }
        }
        .navigationBarBackButtonHidden()
    }

    var id: String { name }
}

struct AboutMainView: View {
    let modelList = SwiftUIType.allCases
    var strings: String?
    @State var index: Int = 0

    var body: some View {
        VStack {
            List {
                ForEach(modelList) { model in
                    if #available(iOS 16.0, *) {
                        NavigationLink(model.name, destination: model.targetView)
                            .toolbar(.hidden, for: .tabBar)
                    } else {
                        NavigationLink(model.name, destination: model.targetView)
                    }
                }
            }
        }
    }
    
    func buttonAction() {
        Task { @MainActor in
            await asyncRunTaskMethod()
//            await MainActor.run {
//                ...
//            }
        }
    }

    func asyncRunTaskMethod() async {
        runTask()
    }

    func runTask() {
        var number = 0
        while number < 200000 {
            print("number: \(number)")
            number += 1
            index = number
        }
    }
}

