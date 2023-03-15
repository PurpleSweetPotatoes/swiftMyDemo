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
    var body: UIFont { get }
    var caption1: UIFont { get }
    var caption2: UIFont { get }
}

protocol BQThemeColorProtocol {
    var textDefaultColor: UIColor { get }
    var textSecondColor: UIColor { get }
}


extension BQThemeFontProtocol {
    var title1: UIFont {
        .dynamic(.title1, maxScaleSize: 2)
    }

    var title2: UIFont {
        .preferredFont(forTextStyle: .title2)
    }

    var title3: UIFont {
        .preferredFont(forTextStyle: .title3)

    }

    var body: UIFont {
        UIFont.dynamic(.body, maxScaleSize: 3)
    }

    var caption1: UIFont {
        .preferredFont(forTextStyle: .caption1)
    }

    var caption2: UIFont {
        .preferredFont(forTextStyle: .caption2)
    }
}

extension BQThemeColorProtocol {
    var textDefaultColor: UIColor {
        return UIColor(dark: .white, light: .black)
    }

    var textSecondColor: UIColor {
        return UIColor(dark: .lightGray, light: .gray)
    }
}

