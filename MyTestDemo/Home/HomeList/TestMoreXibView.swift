//
//  TestMoreXibView.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/12/27.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit

class TestMoreXibView: UIView {
    @IBOutlet weak var button: UIButton!
    enum TestType {
        case first
        case last
    }

    static func loadView(type: TestType) -> TestMoreXibView? {
        if let viewList = Bundle.main.loadNibNamed("TestMoreXibView", owner: self) as? [TestMoreXibView] {
            if type == .first {
                return viewList.first
            }
            return viewList.last
        }
        return nil
    }

}
