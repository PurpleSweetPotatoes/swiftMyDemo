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
        setupAppleMap()
//        addCustomHeatMap()
    }
}

// Apple Map
extension HeatMapTestViewController: MKMapViewDelegate {
    var heatMapData: HeatMapDataSource {
        let upperPoint = CLLocationCoordinate2D(latitude: 30.537899, longitude: 104.072451)
        let lowerPoint = CLLocationCoordinate2D(latitude: 30.537598, longitude: 104.073084)
        let count = 100
        var points: [HeatMapPoint] = []
        for _ in 0..<count {
            let addLat = Double(Int.random(in: 0...301)) * 0.000001
            let addLon = Double(Int.random(in: 0...633)) * 0.000001
            points.append(HeatMapPoint(coordinate: CLLocationCoordinate2D(latitude: lowerPoint.latitude + addLat, longitude: upperPoint.longitude + addLon), intensity: Double(Int.random(in: 0...10))))
        }
        return HeatMapDataSource(heatMapPoints: points, radius: 20, geodeticSystem: .gcj02)
    }

    func setupAppleMap() {
        mapView.delegate = self
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)
        mapView.frame = view.bounds
        view.addSubview(mapView)
    }

    func addCustomHeatMap() {
        let overlay = GarminHeatMapOverlay(heatMapData: heatMapData)
        mapView.addOverlay(overlay)
    }


    func mapView( _ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        BQLogger.debug("-=-=-= viewFor overlay")
        if let heatOverlay = overlay as? GarminHeatMapOverlay {
            return GarminHeatMapRenderer(heatMapOverlay: heatOverlay)
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

