//
//  GarminHeatMapOverlay.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/11/6.
//  Copyright © 2023 Garmin All rights reserved
//  

import MapKit

class GarminHeatMapOverlay: NSObject, MKOverlay {
    let heatMapData: HeatMapDataSource
    var coordinate = CLLocationCoordinate2D()
    var boundingMapRect: MKMapRect = MKMapRect()
    var helper = GarminHeatMapHelper()

    var radius: CGFloat {
        CGFloat(heatMapData.radius)
    }

    init(heatMapData: HeatMapDataSource) {
        self.heatMapData = heatMapData
        super.init()
        processHeatMapData()
    }

    func processHeatMapData() {
        guard let firstNode = heatMapData.heatMapPoints.first else { return }
        var upperLeftPoint = MKMapPoint(firstNode.coordinate)
        var lowerRightPoint = upperLeftPoint

        heatMapData.heatMapPoints.map { MKMapPoint($0.coordinate)}.forEach { point in
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
//        boundingMapRect = helper.mapRect(from: CGRect(x: upperLeftPoint.x, y: upperLeftPoint.y, width: width, height: height))
        boundingMapRect = MKMapRect(x: upperLeftPoint.x - radius * 0.5, y: upperLeftPoint.y - radius * 0.5, width: width + radius, height: height + radius)
        coordinate = MKMapPoint(x: upperLeftPoint.x + width * 0.5, y: upperLeftPoint.y + height * 0.5).coordinate
    }

    func getRenderHeatMapPoint(in rect: MKMapRect) -> [HeatMapPoint] {
        heatMapData.heatMapPoints.compactMap { point in
            let mapPoint = MKMapPoint(point.coordinate)
            if rect.contains(mapPoint) {
                return point
            } else {
                return nil
            }
        }
    }
}


