//
//  SkewedOffsetView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/4/3.
//  Copyright © 2023 Garmin All rights reserved
//  

// https://swiftui-lab.com/swiftui-animations-part1/

import SwiftUI

struct CustomSkewedOffset: GeometryEffect {
    enum MoveDirection {
        case left
        case right
    }

    var offset: CGFloat
    var pct: CGFloat
    var direction: MoveDirection

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset, pct)}
        set {
            offset = newValue.first
            pct = newValue.second
        }
    }

    init(offset: CGFloat, pct: CGFloat, direction: MoveDirection) {
        self.offset = offset
        self.pct = pct
        self.direction = direction
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        var skew: CGFloat
        if pct < 0.2 {
            skew = (pct * 5) * 0.5 * (direction == .right ? -1 : 1)
        } else if pct > 0.8 {
            skew = ((1 - pct) * 5) * 0.5 * (direction == .right ? -1 : 1)
        } else {
            skew = 0.5 * (direction == .right ? -1 : 1)
        }
        return ProjectionTransform(CGAffineTransform(1, 0, skew, 1, offset, 0))
    }
}

struct SkewedOffsetView: View {
    @State var move: Bool = false

    var body: some View {
        let animation = Animation.easeInOut(duration: 1.0)
        let skewedOffset = CustomSkewedOffset(offset: move ? 120: -120, pct: move ? 1 : 0, direction: move ? .right : .left)
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .padding([.horizontal], 20)
                .padding([.vertical], 10)
                .background(Color.red)
                .modifier(skewedOffset)
                .animation(animation, value: move)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .padding([.horizontal], 20)
                .padding([.vertical], 10)
                .background(Color.orange)
                .modifier(skewedOffset)
                .animation(animation.delay(0.2), value: move)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .padding([.horizontal], 20)
                .padding([.vertical], 10)
                .background(Color.gray)
                .modifier(skewedOffset)
                .animation(animation.delay(0.4), value: move)
        }
        .onTapGesture {
            move.toggle()
        }
    }
}

struct SkewedOffsetView_Previews: PreviewProvider {
    static var previews: some View {
        SkewedOffsetView()
    }
}
