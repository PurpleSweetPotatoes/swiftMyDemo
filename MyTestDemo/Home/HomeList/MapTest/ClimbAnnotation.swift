//
//  ClimbAnnotation.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/2/1.
//  Copyright © 2024 Garmin All rights reserved
//  

import MapKit

class ClimbAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var clusterId: String? { isCluster ? Self.description() : nil }
    var image = UIImage(named: "mountain_icon")
    var isCluster: Bool = false
    var zIndex: Float = 0 {
        didSet {
            if zIndex >= 60 {
                image = image?.fillColor(.red)
            }
        }
    }
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class MKClusterAnnotationView: MKAnnotationView {

    enum Constants {
        static let annotationViewWidth: CGFloat = 40
        static let labelWidth: CGFloat = 26
    }
    let label = UILabel()

    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                if cluster.memberAnnotations.count < 3 {
                    self.displayPriority = .defaultLow // Avoid clustering
                } else {
                    self.displayPriority = .defaultHigh // Cluster
                }
            }
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(origin: .zero, size: CGSize(width: Constants.annotationViewWidth, height: Constants.annotationViewWidth))
        layer.cornerRadius = Constants.annotationViewWidth * 0.5
        clipsToBounds = true
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        backgroundColor = .blue
        label.backgroundColor = UIColor.cyan
        label.layer.cornerRadius = Constants.labelWidth * 0.5
        label.clipsToBounds = true
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.labelWidth)
        }
    }
}

