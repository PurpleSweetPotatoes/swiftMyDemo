//
//  PolyLineOverlay.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/2/5.
//  Copyright © 2024 Garmin All rights reserved
//  

import MapKit
import Foundation
import BQSwiftKit

class PolyLineOverlay: MKPolyline {
    var strokeColor: UIColor = .cyan
    var lineWidth: CGFloat = 5
    var zIndex: CGFloat = 0
}

extension PolyLineOverlay: BQPolyLine {}
