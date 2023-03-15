//
//  TestViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/13.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(dark: .black, light: .white)
//        view.backgroundColor = UIColor("a6a6a6")
        testLayerColor()

    }

}

private extension TestViewController {
    func testLayerColor() {
        let useColor = UIColor(dark: UIColor("a6a6a6"), light: UIColor("6c6c6c"))
        let subView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 40))
        subView.layer.cornerRadius = 20
        subView.layer.borderWidth = 2
        subView.layer.borderColor = useColor.cgColor
        view.addSubview(subView)

        let compareView = UIView(frame: CGRect(x: 100, y: 200, width: 100, height: 40))
        compareView.backgroundColor = useColor
        view.addSubview(compareView)

        let layer = CALayer()
        layer.frame = CGRect(x: 100, y: 300, width: 100, height: 40)
        layer.borderWidth = 1
        layer.borderColor = useColor.cgColor
        view.layer.addSublayer(layer)
    }
}
