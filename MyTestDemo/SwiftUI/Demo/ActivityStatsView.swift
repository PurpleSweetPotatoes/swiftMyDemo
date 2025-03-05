//
//  ActivityStatsView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/8/21.
//  Copyright © 2024 Garmin All rights reserved
//  

import SwiftUI

struct ActivityStatsView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(alignment: .leading) {
                Color.gray
                    .frame(height: 1)
                    .padding(.top, 14)
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("0.92")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("pdmi")
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                    Image("ic_deco_white")
                        .resizable(capInsets: EdgeInsets())
                        .frame(width: 16, height: 16)
                }
            }
        }
    }
}

#Preview {
    ActivityStatsView()
}
