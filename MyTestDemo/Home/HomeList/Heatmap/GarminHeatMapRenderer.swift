//
//  GarminHeatMapRenderer.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/11/6.
//  Copyright © 2023 Garmin All rights reserved
//
import MapKit
import BQSwiftKit

class GarminHeatMapRenderer: MKOverlayRenderer {
    init(heatMapOverlay: GarminHeatMapOverlay) {
        super.init(overlay: heatMapOverlay)
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let heatMapOverlay = overlay as? GarminHeatMapOverlay else {
            return
        }
        let useRect = rect(for: mapRect)
        let drawRect = rect(for: overlay.boundingMapRect)
        BQLogger.log("drawRect: \(drawRect)")
        let columns = ceil(CGRectGetWidth(useRect) * zoomScale)
        let rows = ceil(CGRectGetHeight(useRect) * zoomScale)
//        let columns = 256
//        let rows = 256
//        let rect = rect(for: overlay.boundingMapRect)
        let arrayLen = columns * rows
//        BQLogger.debug("-=-=-= columns: \(columns), rows: \(rows), arrayLen: \(arrayLen)")
        let points = heatMapOverlay.getRenderHeatMapPoint(in: mapRect)
        if !points.isEmpty {
//            BQLogger.log("points: \(points)")
//            if let cgImage = createBitmapContext(width: Int(columns), height: Int(rows)) {
//                context.setAlpha(0.5)
//                context.draw(cgImage, in: drawRect)
//            }
            // draw color for everyone node
            drawWithDot(context: context, heatMapPoints: points, zoomScale: zoomScale)
        }
    }

    func createBitmapContext(width: Int, height: Int) -> CGImage? {
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        let bitmapBytesPerRow = width * 4
        let bitmapByteCount = bitmapBytesPerRow * height
        BQLogger.log("bitmap width: \(width), height: \(height)")
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bufferData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
        defer {
            bufferData.deallocate()
        }
        for row in 0..<height {
            for column in 0..<width {
                let offset = bitmapBytesPerRow * row + 4 * column
                if row >= height / 2 - 10 && row <= height / 2 + 10 {
                    // Red
                    (bufferData + offset).initialize(to: 255)
                    // Alpha
                    (bufferData + offset + 3).initialize(to: 255)
                }
//                // Green
//                (bufferData + offset + 1).initialize(to: 0)
//                // Blue
//                (bufferData + offset + 2).initialize(to: 0)
//                // Alpha
//                (bufferData + offset + 3).initialize(to: 255)
            }
        }
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrderDefault.rawValue
        let context = CGContext(data: bufferData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        return context?.makeImage()
    }

    func drawWithDot(context: CGContext, heatMapPoints: [HeatMapPoint], zoomScale: MKZoomScale) {
        guard let heatMapOverlay = overlay as? GarminHeatMapOverlay else {
            return
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        for node in heatMapPoints {
            let mapPoint = MKMapPoint(node.coordinate)
            let center = point(for: mapPoint)
            let colors: [CGFloat] = [
                0xff/255, 0x00/255, 0x00/255, 0.5,
                0x00/255, 0xff/255, 0x00/255, 0.5,
                0x00/255, 0x00/255, 0xff/255, 0.5]
            let locations: [CGFloat] = [0, 0.5, 1]
            if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: locations, count: locations.count) {
                let endRadius = CGFloat(heatMapOverlay.radius) * 0.5 / min(zoomScale, 1)
                let startRadius = CGFloat(heatMapOverlay.radius) * 0.15 / min(zoomScale, 1)
                context.drawRadialGradient(gradient, startCenter: center, startRadius: startRadius, endCenter: center, endRadius: endRadius, options: .drawsBeforeStartLocation)
            }
        }
    }
}
