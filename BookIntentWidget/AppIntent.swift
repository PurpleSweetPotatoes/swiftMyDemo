//
//  AppIntent.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/8/6.
//  Copyright © 2024 Garmin All rights reserved
//  

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "Selected Book", optionsProvider: StringOptionsProvider())
    var bookName: String?

    struct StringOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            let books = try await BookManager.fetchData()
            return books.compactMap { $0.name }
        }
    }
}
