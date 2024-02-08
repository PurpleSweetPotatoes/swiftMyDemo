//
//  GarminHeatMapHelper.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/11/6.
//  Copyright © 2023 Garmin All rights reserved
//  

import MapKit
import BQSwiftKit

struct GarminHeatMapHelper {
    let heatMapMaxDistance: CGFloat

    init(heatMapMaxDistance: CGFloat = 10_000) {
        self.heatMapMaxDistance = heatMapMaxDistance
    }

    func mapRect(from rect: CGRect) -> MKMapRect {
        MKMapRect(x: rect.origin.x - heatMapMaxDistance * 0.5, y: rect.origin.y  - heatMapMaxDistance * 0.5, width: rect.width + heatMapMaxDistance, height: rect.height + heatMapMaxDistance)
    }

    func createBitmapContext(size: CGSize, points: [CGPoint], radius: UInt) -> CGImage? {
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        let columns = Int(size.width)
        let rows = Int(size.height)
        let bitmapBytesPerRow = columns * 4
        let bitmapByteCount = bitmapBytesPerRow * rows

        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bufferData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
        defer {
            bufferData.deallocate()
        }

        for row in 0..<rows {
            for column in 0..<columns {
                let offset = bitmapBytesPerRow * row + 4 * column

                (bufferData + offset).initialize(to: 255)
                // Alpha
                (bufferData + offset + 3).initialize(to: 255)
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
        let context = CGContext(data: bufferData, width: columns, height: rows, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        return context?.makeImage()
    }

}
