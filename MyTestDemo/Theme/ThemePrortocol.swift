//
//  Font+extension.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/12.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit
import SwiftUI

protocol BQThemeFontProtocol {
    var title1: UIFont { get }
    var title2: UIFont { get }
    var title3: UIFont { get }
    var title4: UIFont { get }
    var body: UIFont { get }
    var callout: UIFont { get }
    var content: UIFont { get }
    var footnote: UIFont { get }
    var caption: UIFont { get }
}

protocol BQThemeColorProtocol {
    var backgroundDefaultColor: UIColor { get }
    var textDefaultColor: UIColor { get }
    var textSecondColor: UIColor { get }
}

extension BQThemeFontProtocol {
    var title1: UIFont { .dynamicFont(.title1) }
    var title2: UIFont { .dynamicFont(.title2) }
    var title3: UIFont { .dynamicFont(.title3) }
    var title4: UIFont { .dynamicFont(.title4) }
    var body: UIFont { .dynamicFont(.body) }
    var callout: UIFont { .dynamicFont(.callout) }
    var content: UIFont { .dynamicFont(.content) }
    var footnote: UIFont { .dynamicFont(.footnote) }
    var caption: UIFont { .dynamicFont(.caption) }
}

extension BQThemeColorProtocol {
    var textDefaultColor: UIColor {
        return UIColor(dark: .white, light: .black)
    }

    var textSecondColor: UIColor {
        return UIColor(dark: .lightGray, light: .gray)
    }

    var backgroundDefaultColor: UIColor {
        return UIColor(dark: .black, light: .white)
    }
}

