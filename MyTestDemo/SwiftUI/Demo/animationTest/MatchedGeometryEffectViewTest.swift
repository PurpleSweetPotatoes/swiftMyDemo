//
//  MatchedGeometryEffectViewTest.swift
//  SwiftUITestDemo
//
//  Created by Bai, Payne on 2023/4/4.
//

import SwiftUI

extension EnvironmentValues {
    struct FrameSizeKey: EnvironmentKey {
        public static let defaultValue: Double = 4
    }

    var frameSizeKey: Double {
        get { return self[FrameSizeKey.self] }
        set { self[FrameSizeKey.self] = newValue }
    }
}

extension AnyTransition {

    struct ScaleModifier: Animatable, ViewModifier {
        var size, opacity: Double

        var animatableData: Double {
            get { size }
            set { size = newValue }
        }

        func body(content: Content) -> some View {
            GeometryReader { proxy in
                return content.opacity(opacity).scaleEffect(opacity == 1 ? 1 : size / proxy.size.width)
            }
        }
    }

    static func frameChanged(size: Double, activeOpacity: Bool) -> AnyTransition {
        AnyTransition.modifier(
            active: ScaleModifier(size: size, opacity: activeOpacity ? 0 : 1),
            identity: ScaleModifier(size: size, opacity: activeOpacity ? 1 : 0)
        )
    }
}

struct MatchedGeometryEffectViewTest: View {

    var body: some View {
        Example1()
    }

    struct Example1: View {
        @Namespace private var animation
        @State private var isFlipped = false

        var body: some View {
            VStack {
                if isFlipped {
                    Spacer()
                    Text("Taylor Swift – 1989")
                        .font(.headline)
                        .matchedGeometryEffect(id: "text", in: animation)
                } else {
                    Text("Taylor Swift – asdadasdasdasda")
                        .font(.headline)
                        .matchedGeometryEffect(id: "text", in: animation)
                    Spacer()
                }
            }
            .onTapGesture {
                withAnimation {
                    isFlipped.toggle()
                }
            }
        }
    }

    struct Example2: View {
        @Namespace private var animation
        @State private var isZoomed = false
        var frame: CGFloat {
            isZoomed ? 200 : 44
        }
        var body: some View {
            VStack {
                if !isZoomed {
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: frame, height: frame)
                            .matchedGeometryEffect(id: "image", in: animation, properties: .position)
                        Text("Taylor Swift – 1989")
                            .font(.headline)
                            .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                        Spacer()
                    }
                } else {
                    VStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: frame, height: frame)
                            .matchedGeometryEffect(id: "image", in: animation, properties: .position)
                        Text("Taylor Swift – 1989")
                            .font(.headline)
                            .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                            .padding(.bottom, 60)
                    }
                }
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    isZoomed.toggle()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 400)
            .background(Color(white: 0.9))
            .foregroundColor(.black)
        }
    }

    struct Example3: View {
        @State private var swap = false
        @Namespace private var dotTransition

        var body: some View {
            if swap {

                // After swap
                // Green dot on the left, Orange dot on the right

                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 30, height: 30)
                        .matchedGeometryEffect(id: "greenCircle", in: dotTransition)

                    Spacer()

                    Circle()
                        .fill(Color.orange)
                        .frame(width: 30, height: 30)
                        .matchedGeometryEffect(id: "orangeCircle", in: dotTransition)
                }
                .frame(width: 100)
                .animation(.linear)
                .onTapGesture {
                    swap.toggle()
                }

            } else {

                // Start state
                // Orange dot on the left, Green dot on the right

                HStack {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 30, height: 30)
                        .matchedGeometryEffect(id: "orangeCircle", in: dotTransition)

                    Spacer()

                    Circle()
                        .fill(Color.green)
                        .frame(width: 30, height: 30)
                        .matchedGeometryEffect(id: "greenCircle", in: dotTransition)
                }
                .frame(width: 100)
                .animation(.linear)
                .onTapGesture {
                    swap.toggle()
                }
            }
        }
    }
}

struct MatchedGeometryEffectViewTest_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeometryEffectViewTest()
    }
}
