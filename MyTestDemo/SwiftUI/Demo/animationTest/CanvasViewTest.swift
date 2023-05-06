//
//  CanvasViewTest.swift
//  SwiftUITestDemo
//
//  Created by Bai, Payne on 2023/4/4.
//

import SwiftUI
@available(iOS 15.0, *)
struct CanvasViewTest: View {
    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size).insetBy(dx: 12.5, dy: 12.5)
            let path = Path(roundedRect: rect, cornerRadius: 20.0)
            let gradient = Gradient(colors: [.green, .blue])
            let from = rect.origin
            let to = CGPoint(x: rect.width
                             + from.x, y: rect.height + from.y)

            context.stroke(path, with: .color(Color.gray), lineWidth: 25)
            context.fill(path, with: .linearGradient(gradient, startPoint: from, endPoint: to))
            let resolved = context.resolve(Text("\(rect.width) -- \(rect.height)\n\(size.width) -- \(size.height)").foregroundColor(Color.white))
            context.draw(resolved, at: CGPoint(x: size.width * 0.5, y: size.height * 0.5), anchor: .center)
        }
    }
}

struct CanvasViewTest_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            CanvasViewTest()
        }
    }
}
