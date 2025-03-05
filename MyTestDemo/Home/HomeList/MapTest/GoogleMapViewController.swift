//
//  GoogleMapViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/2/7.
//  Copyright © 2024 Garmin All rights reserved
//  

import UIKit
import GoogleMaps
import BQSwiftKit

class GoogleMapViewController: UIViewController {
    private let mapView = GMSMapView()
    private var mapType: GMSMapViewType = .normal
    private var marker: GMSMarker?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    @objc func addMark() {
//        self.marker?.map = nil
//        self.marker = nil
//        let marker = GMSMarker()
//        marker.position = mapView.camera.target
//        marker.title = "\(marker.position.latitude)\n \(marker.position.longitude)"
//        marker.map = mapView
//        self.marker = marker
        print("-=-=- zoomLevel: \(mapView.camera.zoom)")
        print("-=-=- longdetal: \(mapView.projection.visibleRegion())")
        mapView.animate(toBearing: CLLocationDirection(arc4random_uniform(360)))
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            print("-=-=- zoomLevel: \(self.mapView.camera.zoom)")
            print("-=-=- longdetal: \(self.mapView.projection.visibleRegion())")
        })
    }

    @objc func showMyLocation() {
    }

    @objc func switchMapType() {
        if mapType == .satellite,
           let marker {
            marker.position = marker.position.transformWGS84ToGCJ02()
        }
        mapType = mapType == .normal ? .satellite : .normal

        mapView.mapType = mapType
    }
}

private extension GoogleMapViewController {
    func setupUI() {
        setupNavigation()
        setupMapView()
        setupCeterView()
        setupSwitchTypeButton()
    }

    func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add mark", style: .plain, target: self, action: #selector(showMyLocation))
    }

    func setupMapView() {
        mapView.frame = view.bounds
        mapView.insetsLayoutMarginsFromSafeArea = false
        mapView.mapType = mapType
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
    }

    func setupCeterView() {
        let centerView = UIView()
        centerView.backgroundColor = .red
        centerView.layer.cornerRadius = 10
        centerView.alpha = 0.3
        view.addSubview(centerView)
        centerView.snp.makeConstraints {
            $0.center.equalTo(mapView.snp.center)
            $0.size.equalTo(20)
        }
    }

    func setupSwitchTypeButton() {
        let bottomBtn = UIButton(frame: .zero, text: "switch", textColor: .white)
        bottomBtn.addTarget(self, action: #selector(switchMapType), for: .touchUpInside)
        bottomBtn.backgroundColor = .cyan
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.trailing.equalToSuperview().inset(50)
            $0.size.equalTo(50)
        }
    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        print("-=-=-= mapViewSnapshotReady")
    }
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        print("-=-=-= mapViewDidFinishTileRendering")
    }
}
