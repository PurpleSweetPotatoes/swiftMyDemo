//
//  AppleMapTestViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/2/1.
//  Copyright © 2024 Garmin All rights reserved
//  

import UIKit
import MapKit
import BQSwiftKit
import SwiftUI

class AppleMapTestViewController: UIViewController {
    private let mapView = MyMap()
    private let location = CLLocationCoordinate2D(latitude: 30.539264, longitude: 104.073316)
    private var annotations: [MKAnnotation] = []
    private var edge: UIEdgeInsets {
        UIEdgeInsets(top: 95, left: 32, bottom: (view.bounds.height * 0.5) + 70, right: 32)
    }

    private var polylineList: [MKOverlay] = []
    private var markerList: [MKAnnotation] = []

    var markZIndex: Float = -60
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            print("-=-= start zoomLevel: \(self.mapView.zoomLevel)")
        })
    }

    @objc
    func navigationActionClick() {

        let alertVC = UIAlertController(title: "Action", message: "add location at screen center", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Add Cluster Annotation", style: .default) { _ in
            self.markZIndex += 1
            self.addAnnotation(zPostion: self.markZIndex, isCluster: false)
        })

        alertVC.addAction(UIAlertAction(title: "Add China Bounds line", style: .default) { _ in
            self.addChinaBounds()
        })

        alertVC.addAction(UIAlertAction(title: "Remove All Annotation", style: .default) { _ in
            self.mapView.removeAnnotations(self.annotations)
        })

        alertVC.addAction(UIAlertAction(title: "Convert mark to polyLine ", style: .default) { _ in
            self.addPolyLineWithMark()
        })


        alertVC.addAction(UIAlertAction(title: "Remove & Add again", style: .default) { _ in
            self.removeAndAdd()
        })

        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        navigationController?.present(alertVC, animated: true)
    }
}

// MARK: - *** Map set
private extension AppleMapTestViewController {
    func addAnnotation(zPostion: Float = 0, coordinate: CLLocationCoordinate2D? = nil, isCluster: Bool = false) {
        let centerCoordinate = coordinate ?? mapView.centerCoordinate
        let annotation = ClimbAnnotation(coordinate: centerCoordinate)
        annotation.isCluster = isCluster
        annotation.zIndex = zPostion
        mapView.addAnnotation(annotation)
        annotations.append(annotation)
    }

    func addChinaBounds() {
        let chinaPoints = MapUtils.getCountryBounds(.china)
        let ChinaPolyline = PolyLineOverlay(coordinates: chinaPoints, count: chinaPoints.count)
        ChinaPolyline.strokeColor = .black
        ChinaPolyline.lineWidth = 8
        ChinaPolyline.zIndex = -61

        let mainlandChinaPoints = MapUtils.getCountryBounds(.mainlandChina)
        let mainlandChinaPolyline = PolyLineOverlay(coordinates: mainlandChinaPoints, count: mainlandChinaPoints.count)
        mainlandChinaPolyline.lineWidth = 5
        mainlandChinaPolyline.zIndex = -60
        mapView.add(polyline: mainlandChinaPolyline)
        mapView.add(polyline: ChinaPolyline)
    }

    func addPolyLineWithMark() {
        let points = mapView.annotations
            .compactMap { $0 as? ClimbAnnotation }
            .sorted { $0.zIndex < $1.zIndex }
            .map { $0.coordinate }
        mapView.removeAnnotations(mapView.annotations)

//        let backgroundPolyLine = PolyLineOverlay(coordinates: points, count: points.count)
//        backgroundPolyLine.strokeColor = .black
//        backgroundPolyLine.lineWidth = 8
//        backgroundPolyLine.zIndex = -61

        let foregroundPolyLine = PolyLineOverlay(coordinates: points, count: points.count)
        foregroundPolyLine.lineWidth = 4
        foregroundPolyLine.zIndex = -60
        mapView.add(polyline: foregroundPolyLine)
        let newPoints = points.compactMap { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude + 0.001) }
        let comparePolyline = MKPolyline(coordinates: newPoints, count: newPoints.count)
        mapView.addOverlay(comparePolyline)
    }

    func removeAndAdd() {
        print("-=-=-= removeAndAdd remove")
        for _ in 0..<3 {
            polylineList = mapView.overlays
            mapView.removeOverlays(polylineList)
            print("-=-=-= removeAndAdd add polyline")
            for polyLine in polylineList {
                mapView.addOverlay(polyLine)
                print("-=-=-= add one polyline")
            }

            markerList = mapView.annotations
            mapView.removeAnnotations(markerList)
            print("-=-=-= removeAndAdd add annotation")
            for marker in markerList {
                mapView.addAnnotation(marker)
                print("-=-=-= add one annotation")
            }
        }
        print("-=-=-= removeAndAdd end")
    }
}

// MARK: - *** UI
private extension AppleMapTestViewController {
    func setupUI() {
        setupNavigationButton()
        setupMapView()
        setupCeterView()
        setupMapFitLine()
    }

    func setupNavigationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "action", style: .plain, target: self, action: #selector(navigationActionClick))
    }

    func setupMapView() {
        mapView.insetsLayoutMarginsFromSafeArea = false
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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

    func setupMapFitLine() {
        func addLineView(frame: CGRect) {
            let lineView = UIView(frame: frame)
            lineView.backgroundColor = .red
            view.addSubview(lineView)
        }
        addLineView(frame: CGRect(x: 0, y: edge.top, width: view.sizeW, height: 1))
        addLineView(frame: CGRect(x: 0, y: view.sizeH - edge.bottom, width: view.sizeW, height: 1))
        addLineView(frame: CGRect(x: edge.left, y: 0, width: 1, height: view.sizeH))
        addLineView(frame: CGRect(x: view.sizeW - edge.right, y: 0, width: 1, height: view.sizeH))
    }
}

extension AppleMapTestViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            if let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: MKClusterAnnotation.description()) as? MKClusterAnnotationView {
                clusterView.label.text = "\(clusterAnnotation.memberAnnotations.count)"
                return clusterView
            }
            let clusterView = MKClusterAnnotationView(annotation: annotation, reuseIdentifier: MKClusterAnnotation.description())
            clusterView.label.text = "\(clusterAnnotation.memberAnnotations.count)"
            clusterView.prepareForDisplay()
            return clusterView
        } else if let climbAnnotation = annotation as? ClimbAnnotation {

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:  MKAnnotationView.description())
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: climbAnnotation, reuseIdentifier: MKAnnotationView.description())
            }

            annotationView?.annotation = annotation
            annotationView?.clusteringIdentifier = climbAnnotation.clusterId
            annotationView?.image = climbAnnotation.image
            annotationView?.zPriority = MKAnnotationViewZPriority(rawValue: climbAnnotation.zIndex)

            return annotationView
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        print("-=-=-= select view \(annotation.description)")
        self.mapView(mapView, didSelect: annotation)
    }

    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        print("-=-=-= \(#function)")
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            let locations = clusterAnnotation.memberAnnotations.compactMap {
                $0.coordinate
            }
            mapView.fit(points: locations, animated: true, insets: edge)
        } else if let climbAnnotation = annotation as? ClimbAnnotation {
            mapView.removeAnnotation(annotation)
            addAnnotation(zPostion: 61, coordinate: annotation.coordinate)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? BQPolyLine {
            let polyLineRender = MKBorderPathRenderer(polyline: polyline as! MKPolyline)
            polyLineRender.strokeColor = polyline.strokeColor
            polyLineRender.lineWidth = polyline.lineWidth
            return polyLineRender
        } else if let comparePolyline = overlay as? MKPolyline {
            let polyLineRender = MKPolylineRenderer(polyline: comparePolyline)
            polyLineRender.strokeColor = UIColor.red
            polyLineRender.lineWidth = 4
            return polyLineRender
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("current zoomLevel: \(mapView.zoomLevel)")
    }
}

extension UIEdgeInsets {
    /// Each component of this value by the given value.
    func scale(by rhs: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: self.top * rhs,
                     left: self.left * rhs,
                     bottom: self.bottom * rhs,
                     right: self.right * rhs)
    }
}

extension MKMapView {
    var zoomLevel: Double {
        let mercatorRadius = 85445659.44705395
        let maxZoomLevel = 21.0
        // The heading of the camera will affect the longitude of the region center, so it's necessary to reset the heading of the camera.
        var angleCamera = camera.heading
        if angleCamera > 180 {
            angleCamera -= 180
        }
        if angleCamera > 90 {
            angleCamera = 180 - angleCamera
        }
        let scaledMapWidth: Double = region.span.longitudeDelta * mercatorRadius * .pi / 180.0
        var displayWidth = Double(bounds.width)
        let heightOffset = insetsLayoutMarginsFromSafeArea ? Double(safeAreaInsets.top + safeAreaInsets.bottom) : 0
        if angleCamera != 0 {
            displayWidth = bounds.width * cos(Double.pi * angleCamera / 180) + (bounds.height - heightOffset) * sin(Double.pi * angleCamera / 180)
        }
        return maxZoomLevel - log2(scaledMapWidth / displayWidth)
    }
}
