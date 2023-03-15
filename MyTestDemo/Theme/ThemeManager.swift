//
//  ThemeManager.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/12.
//  Copyright © 2023 Garmin All rights reserved
//  

import Foundation
import BQSwiftKit

struct ThemeManager {
    static var uiFont: BQThemeFontProtocol = BQUIFont()
    static var uiColor: BQThemeColorProtocol = BQUIColor()
}

private struct BQUIFont: BQThemeFontProtocol {}
private struct BQUIColor: BQThemeColorProtocol {}
