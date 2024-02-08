//
//  HeatMapDataSource.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/11/6.
//  Copyright © 2023 Garmin All rights reserved
//  

import Foundation
import CoreLocation

public enum GeodeticSystem {
    case wgs84
    case gcj02
}

public protocol GarminHeatMapDataSource {
    var heatMapPoints: [HeatMapPoint] { get }
    var radius: UInt { get }
    var geodeticSystem: GeodeticSystem { get }
}

struct HeatMapDataSource: GarminHeatMapDataSource {
   let heatMapPoints: [HeatMapPoint]
   let radius: UInt
   let geodeticSystem: GeodeticSystem
}

public struct HeatMapPoint {
    public let coordinate: CLLocationCoordinate2D
    public let intensity: Double

    public init(coordinate: CLLocationCoordinate2D, intensity: Double) {
        self.coordinate = coordinate
        self.intensity = intensity
    }
}
