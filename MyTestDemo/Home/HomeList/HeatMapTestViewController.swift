//
//  HeatmapTestViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/10/12.
//  Copyright © 2023 Garmin All rights reserved
//  

import Foundation
import MapKit
import BQSwiftKit

struct HeatModel: Codable {
    let lat: CLLocationDegrees
    let lng: CLLocationDegrees
    let count: Int
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2DMake(lat, lng)
    }
}

class GarminHeatMapOverlay: NSObject, MKOverlay {
    let nodes: [HeatModel]
    var coordinate = CLLocationCoordinate2D()
    var boundingMapRect: MKMapRect = MKMapRect()
    var radius: CGFloat = 20

    init(heatModels: [HeatModel]) {
        nodes = heatModels
        super.init()
        processNodes()
    }

    func processNodes() {
        guard let firstNode = nodes.first else { return }
        var upperLeftPoint = MKMapPoint(firstNode.coordinate)
        var lowerRightPoint = upperLeftPoint
        
        nodes.map { MKMapPoint($0.coordinate)}.forEach { point in
            if point.x < upperLeftPoint.x {
                upperLeftPoint.x = point.x
            }
            if point.y < upperLeftPoint.y {
                upperLeftPoint.y = point.y
            }
            if point.x > lowerRightPoint.x {
                lowerRightPoint.x = point.x
            }
            if point.y > lowerRightPoint.y {
                lowerRightPoint.y = point.y
            }
        }

        let width = lowerRightPoint.x - upperLeftPoint.x
        let height = lowerRightPoint.y - upperLeftPoint.y
        boundingMapRect = MKMapRect(x: upperLeftPoint.x - radius * 0.5, y: upperLeftPoint.y  - radius * 0.5, width: width + radius, height: height + radius)
        coordinate = MKMapPoint(x: upperLeftPoint.x + width * 0.5, y: upperLeftPoint.y + height * 0.5).coordinate
    }
}

class GarminHeatMapRenderer: MKOverlayRenderer {

    init(heatMapOverlay: GarminHeatMapOverlay) {
        super.init(overlay: heatMapOverlay)
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let heatMapOverlay = overlay as? GarminHeatMapOverlay else {
            return
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let deviceRect = rect(for: mapRect)
        BQLogger.debug("-=-=-= draw mapRect: \(deviceRect)")
        BQLogger.debug("-=-=-= zoomScale: \(zoomScale)")
        var fillRect = rect(for: heatMapOverlay.boundingMapRect)
        BQLogger.debug("-=-=-= draw fillRect: \(fillRect)")
        if let cgImage = createBitmapContext(width: Int(fillRect.width), height: Int(fillRect.height)) {
            BQLogger.debug("-=-=-= draw image")
            context.setAlpha(0.6)
            context.draw(cgImage, in: fillRect)
        }

        // draw color for everyone node
        for node in heatMapOverlay.nodes {
            let mapPoint = MKMapPoint(node.coordinate)
            let center = point(for: mapPoint)
            let colors: [CGFloat] = [
                0xff/255, 0x00/255, 0x00/255, 1,
                0x00/255, 0xff/255, 0x00/255, 1,
                0x00/255, 0x00/255, 0xff/255, 1]
            let locations: [CGFloat] = [0, 0.5, 1]
            if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: locations, count: locations.count) {
//                let endRadius = 2 * MKMapPointsPerMeterAtLatitude(node.coordinate.latitude)
                let endRadius = heatMapOverlay.radius * 0.5
                let startRadius = heatMapOverlay.radius * 0.15
                context.drawRadialGradient(gradient, startCenter: center, startRadius: startRadius, endCenter: center, endRadius: endRadius, options: .drawsBeforeStartLocation)
            }
        }
    }

    func createBitmapContext(width: Int, height: Int) -> CGImage? {
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        let bitmapBytesPerRow = width * 4
        let bitmapByteCount = bitmapBytesPerRow * height

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
                // Red
                (bufferData + offset).initialize(to: 0)
                // Green
                (bufferData + offset + 1).initialize(to: 0)
                // Blue
                (bufferData + offset + 2).initialize(to: 0)
                // Alpha
                (bufferData + offset + 3).initialize(to: 100)
            }
        }
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrderDefault.rawValue
        let context = CGContext(data: bufferData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Make sure and release colorspace before returning
        return context?.makeImage()
    }
}

class HeatMapTestViewController: UIViewController {
    private let mapView = MKMapView()
    private let latitude: CLLocationDegrees = 30.539264
    private let longitude: CLLocationDegrees = 104.073316

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Apple Heat Map Test"
        setupUI()
    }

    private func setupUI() {
        configAppleMap()
        addCustomHeatMap()
    }
}

// Apple Map
extension HeatMapTestViewController: MKMapViewDelegate {
    var heatModels: [HeatModel] {
        if let path = Bundle.main.path(forResource: "HeatLocations_apple", ofType: "json"),
           let jsonStr = try? String(contentsOfFile: path) {
            return Array.decodeJSON(from: jsonStr, parsePath: "list") ?? []
        }
        return []
    }

    func configAppleMap() {
        mapView.delegate = self
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)
        mapView.frame = view.bounds
        view.addSubview(mapView)
    }

    func addCustomHeatMap() {
        let overlay = GarminHeatMapOverlay(heatModels: heatModels)
        mapView.addOverlay(overlay)
    }

//    func addDTMHeatMap() {
//        let heatmap = DTMHeatmap()
//
//        let ret = NSMutableDictionary()
//        if let path = Bundle.main.path(forResource: "mcdonalds", ofType: "txt"),
//           let content = try? String(contentsOfFile: path, encoding: .utf8) {
//            let lines = content.components(separatedBy: CharacterSet.newlines)
//            for line in lines {
//                let paras = line.components(separatedBy: ",")
//                if let lat = Double(paras[0]),
//                   let lng = Double(paras[1]) {
//                    var point = MKMapPoint(CLLocationCoordinate2DMake(lat, lng))
//                    let type = "{MKMapPoint=dd}"
//                    let value = NSValue(bytes: &point, objCType: type)
//                    ret[value] = 1.0
//                }
//            }
//        }
//        heatmap.setData(ret as! [NSObject : Any])
//        mapView.addOverlay(heatmap)
//    }

    func mapView( _ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        BQLogger.debug("-=-=-= viewFor overlay")
        if let heatOverlay = overlay as? GarminHeatMapOverlay {
            return GarminHeatMapRenderer(heatMapOverlay: heatOverlay)
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

