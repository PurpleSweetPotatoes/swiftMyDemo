//
//  AppIntent.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/8/5.
//  Copyright © 2024 Garmin All rights reserved
//  

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
