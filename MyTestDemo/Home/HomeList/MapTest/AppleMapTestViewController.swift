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

class AppleMapTestViewController: UIViewController {
    
    private let mapView = MKMapView()
    private let location = CLLocationCoordinate2D(latitude: 30.539264, longitude: 104.073316)
    private var annotations: [MKAnnotation] = []
    private var edge: UIEdgeInsets {
        UIEdgeInsets(top: 95, left: 32, bottom: (view.bounds.height * 0.5) + 70, right: 32)
    }

    var markZIndex: Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupUI()
    }

    @objc
    func navigationActionClick() {
        let alertVC = UIAlertController(title: "Action", message: "add location at screen center", preferredStyle: .actionSheet)

        alertVC.addAction(UIAlertAction(title: "Add Cluster Annotation", style: .default) { _ in
            self.markZIndex += 1
            self.addAnnotation(zPostion: self.markZIndex, isCluster: true)
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

        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        navigationController?.present(alertVC, animated: true)
    }
}

// MARK: - *** Map set
private extension AppleMapTestViewController {
    func addAnnotation(zPostion: Float = 0, isCluster: Bool = false) {
        let centerCoordinate = mapView.centerCoordinate
        let annotation = ClimbAnnotation(coordinate: centerCoordinate)
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

        let backgroundPolyLine = PolyLineOverlay(coordinates: points, count: points.count)
        backgroundPolyLine.strokeColor = .black
        backgroundPolyLine.lineWidth = 8
        backgroundPolyLine.zIndex = -61

        let foregroundPolyLine = PolyLineOverlay(coordinates: points, count: points.count)
        foregroundPolyLine.lineWidth = 5
        foregroundPolyLine.zIndex = -60
        mapView.add(polyline: foregroundPolyLine)
        mapView.add(polyline: backgroundPolyLine)
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
        mapView.frame = view.bounds
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
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:  MKAnnotationView.description()) {
                return annotationView
            }
            let annotationView = MKAnnotationView(annotation: climbAnnotation, reuseIdentifier: MKAnnotationView.description())
            annotationView.clusteringIdentifier = climbAnnotation.clusterId
            annotationView.image = climbAnnotation.image
            return annotationView
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer]) {
    }

    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            let locations = clusterAnnotation.memberAnnotations.compactMap {
                $0.coordinate
            }
            mapView.fit(points: locations, animated: true, insets: edge)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? BQPolyLine {
            let polyLineRender = MKPolylineRenderer(overlay: overlay)
            polyLineRender.strokeColor = polyline.strokeColor
            polyLineRender.lineWidth = polyline.lineWidth
            return polyLineRender
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
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
