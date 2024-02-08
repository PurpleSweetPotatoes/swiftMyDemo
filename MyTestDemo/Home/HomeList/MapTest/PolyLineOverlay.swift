//
//  PolyLineOverlay.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/2/5.
//  Copyright © 2024 Garmin All rights reserved
//  

import MapKit
import Foundation

class BQPolyLine: MKPolyline {
    var color: UIColor?
    var lineWidth: CGFloat = 5
    var zIndex: CGFloat = 0
}
