//
//  HikeView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/4/3.
//  Copyright © 2023 Garmin All rights reserved
//  

import SwiftUI

extension AnyTransition {
    static var movAndFade: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .scale.combined(with: .opacity))
    }
}

struct HikeView: View {
    var hike: Hike
    @State private var showDetail = false

    var body: some View {
        VStack {
            HStack {
                HikeGraph(hike: hike, path: \.elevation)
                    .frame(width: 50, height: 30)

                VStack(alignment: .leading) {
                    Text(hike.name)
                        .font(.headline)
                    Text(hike.distanceText)
                        .blur(radius: showDetail ? 4 : 0)
                }

                Spacer()

                Button {
                    withAnimation() {
                        showDetail.toggle()
                    }
                } label: {
                    Label("", systemImage: "chevron.right.circle")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        .scaleEffect(showDetail ? 1.5 : 1)
                        .padding()
                        .animation(.linear, value: showDetail)
                }
            }

            if showDetail {
                HikeDetail(hike: hike)
                    .transition(.movAndFade)
            }
        }
    }
}

struct HikeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HikeView(hike: ModelData().hikes[0])
                .padding()
            Spacer()
        }
    }
}
