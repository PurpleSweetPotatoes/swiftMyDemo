//
//  SwiftUITestView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/6/1.
//  Copyright © 2023 Garmin All rights reserved
//  

import SwiftUI

struct SwiftUITestView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .background(Color.orange)
            Rectangle()
                .foregroundColor(Color.black)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SwiftUITestView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUITestView()
    }
}
