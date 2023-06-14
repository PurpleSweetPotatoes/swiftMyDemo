//
//  SwiftUIView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/13.
//  Copyright © 2023 Garmin All rights reserved
//  

import SwiftUI
import BQSwiftKit

struct DoughnutData: DoughutViewData {
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
        VStack {
            DoughnutView(data: DoughnutData()) {
                VStack(alignment: .center) {
                    VStack {
                        Spacer()
                        Text("ABC")
                    }
                    VStack {
                        Text("ccc")
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 100)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
