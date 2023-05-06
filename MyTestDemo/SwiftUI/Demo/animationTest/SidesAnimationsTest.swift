//
//  SidesAnimationsTest.swift
//  SwiftUiDemo
//
//  Created by Bai, Payne on 2023/1/31.
//  Copyright © 2023 Garmin All rights reserved
//

import SwiftUI

// MARK: - SidesAnimationsTest
struct SidesAnimationsTest: View {
    @Namespace var nSpace
    @State private var flag: Bool = true
    var body: some View {
        HStack {
            if flag {
                VStack {
                    Polygon(color: Color.green)
                        .matchedGeometryEffect(id: "geoeffect1", in: nSpace)
                        .frame(width: 200, height: 200)
                }
                .transition(.polygonTriangle)
            }
            Spacer()
            Button("Switch") {
                withAnimation(.easeInOut(duration: 2)) {
                    flag.toggle()
                }
            }
            Spacer()
            if !flag {
                VStack {
                    Polygon(color: Color.blue)
                        .matchedGeometryEffect(id: "geoeffect1", in: nSpace)
                        .frame(width: 200, height: 200)
                }
                .transition(.polygonCircle)
            }
        }
        .frame(width: 450).padding(40).border(Color.gray, width: 3)
    }
}

extension EnvironmentValues {
    struct PolygonSidesKey: EnvironmentKey {
        public static let defaultValue: Double = 4
    }

    var polygonSides: Double {
        get { return self[PolygonSidesKey.self] }
        set { self[PolygonSidesKey.self] = newValue }
    }
}

struct Polygon: View {
    @Environment(\.polygonSides) var sides: Double
    let color: Color

    var body: some View {
        Group {
            if sides >= 30 {
                Circle().stroke(color, lineWidth: 10)
            } else {
                PolygonShape(sides: sides)
                    .stroke(color, lineWidth: 10)
            }
        }
    }

    struct PolygonShape: Shape {
        var sides: Double
        func path(in rect: CGRect) -> Path {
            let h = Double(min(rect.size.width, rect.size.height)) * 0.5
            let c = CGPoint(x: rect.size.width * 0.5, y: rect.size.height * 0.5)
            var path = Path()
            let extra: Int = sides != Double(Int(sides)) ? 1 : 0

            for i in 0..<Int(sides) + extra {
                let angle = (Double(i) * (360.0 / Double(sides))) * Double.pi / 180
                let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
                if i == 0 {
                    path.move(to: pt)
                } else {
                    path.addLine(to: pt)
                }
            }

            path.closeSubpath()
            return path
        }
    }

}

extension AnyTransition {

    struct PolygonModifier: Animatable, ViewModifier {
        var sides, opacity: Double

        var animatableData: Double {
            get { sides }
            set { sides = newValue }
        }

        func body(content: Content) -> some View {
            return content.environment(\.polygonSides, sides).opacity(opacity)
        }
    }


    static var polygonTriangle: AnyTransition {
        AnyTransition.modifier(
            active: PolygonModifier(sides: 30, opacity: 0),
            identity: PolygonModifier(sides: 3, opacity: 1)
        )
    }

    static var polygonCircle: AnyTransition {
        AnyTransition.modifier(
            active: PolygonModifier(sides: 3, opacity: 0),
            identity: PolygonModifier(sides: 30, opacity: 1)
        )
    }
}

struct SidesExample1: View {
    @State var rotateChanged: Bool = false
    @State var offsetChanged: Bool = false
    @State var colorChanged: Bool = false

    var body: some View {
        VStack {
            Text( "I can do Animation")
                .foregroundColor(.white)
                .padding(20)
                .background(colorChanged ? Color.blue : Color.green)
                .animation(.easeInOut(duration: 2), value: colorChanged)
                .rotationEffect(.degrees(rotateChanged ? 180 : 0))
                .animation(.easeInOut(duration: 0.5), value: rotateChanged)
                .offset(x: offsetChanged ? 120 : -120)
                .animation(.easeInOut(duration: 4), value: offsetChanged)
            Button {
                rotateChanged.toggle()
                colorChanged.toggle()
                withAnimation {
                    offsetChanged.toggle()
                }
            } label: {
                Text("start animation")
            }
        }
    }
}

struct SidesAnimationsTest_Previews: PreviewProvider {
    static var previews: some View {
       SidesExample1()
    }
}
