//
//  BookManager.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/8/6.
//  Copyright © 2024 Garmin All rights reserved
//  

import AppIntents
import WidgetKit

struct Book: Hashable, Codable, Identifiable {
    let name: String
    let author: String
    let rate: Int

    var id: String { name }

    static let tianDao = Book(name: "天道", author: "豆豆", rate: 90)
    static let pingFanDeShiJie = Book(name: "平凡的世界", author: "路遥", rate: 85)
    static let huoZhe = Book(name: "活着", author: "余华", rate: 80)
}

struct BookManager {
    static let appGroup = "group.com.garmin.baipayne.demo"
    static private let currentBookName = "bookName"

    static var availableBooks: [Book] {
        [.tianDao, .pingFanDeShiJie, .huoZhe]
    }
    static func fetchData() async throws -> [Book] {
        availableBooks
    }

    static func book(from name: String) -> Book? {
        availableBooks.first { $0.name == name }
    }

    static func setCurrentBook(with name: String) {
        let book = availableBooks.first { $0.name == name }
        guard let book else {
            return
        }

        UserDefaults(suiteName: Self.appGroup)?.setValue(name, forKey: Self.currentBookName)
    }
}
