//
//  MKBorderPathRenderer.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/5/16.
//  Copyright © 2024 Garmin All rights reserved
//  

import MapKit

public class MKBorderPathRenderer: MKOverlayPathRenderer {
    public var borderColor: UIColor = UIColor.black
    public var borderWidth: CGFloat = 6
    private var polyline: MKPolyline
//    public override var lineWidth: CGFloat {
//        didSet {
//            lineDashPattern = [NSNumber(value: lineWidth), NSNumber(value: lineWidth * 2)]
//        }
//    }

    init(polyline: MKPolyline) {
        self.polyline = polyline
        super.init(overlay: polyline)
        lineJoin = .bevel
        lineJoin = .bevel
    }

    public override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let scale = max(1 / zoomScale, 0.5)

//        scale = mapRect.size.width / UIScreen.main.bounds.width
        print("!!! mapRect.size: \(mapRect.size)")
        print("!!! scale: \(scale)")
//
//        if adjustedZoomScale < 8 {
//            adjustedZoomScale *= 2
//        }

        if borderWidth > 0 {
            context.setLineWidth(borderWidth * scale)
            context.setLineJoin(CGLineJoin.round)
            context.setLineCap(CGLineCap.round)
            context.addPath(path)
            context.setStrokeColor(borderColor.cgColor)
            context.strokePath()
        }

//        if let strokeColor {
//            context.setLineWidth(lineWidth * scale)
//            context.addPath(path)
//            context.setStrokeColor(strokeColor.cgColor)
//            context.strokePath()
//        }
    }

    public override func createPath() {
        let path: CGMutablePath  = CGMutablePath()
        var pathIsEmpty: Bool = true

        for i in 0..<self.polyline.pointCount {
            let point: CGPoint = self.point(for: self.polyline.points()[i])
            if pathIsEmpty {
                path.move(to: point)
                pathIsEmpty = false
            } else {
                path.addLine(to: point)
            }
        }
        self.path = path
    }
}
