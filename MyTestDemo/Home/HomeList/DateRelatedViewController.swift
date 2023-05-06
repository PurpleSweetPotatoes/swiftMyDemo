//
//  DateRelatedViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/23.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit
import BQSwiftKit

class DateRelatedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
}

private extension DateRelatedViewController {
    func setupUI() {
        testMethod()
    }

    func testMethod() -> String {
        let arr = Set([1, 3, 4, 5])
        let arr1 = Set([2, 3, 4, 7])
        let result = Array(arr.intersection(arr1))
        BQLogger.log("交集: \(result)")
        let date = Date()
        let testDateString = "2023-03-23 12:00:00"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let testDate = formatter.date(from: testDateString) else {
            return "时间转化失败"
        }
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        guard let testDate1 = formatter.date(from: testDateString) else {
            return "时间1转化失败"
        }
        BQLogger.log("local date: \(date)")
        BQLogger.log("local testDate: \(testDate)")
        BQLogger.log("local testDate1: \(testDate1)")

        BQLogger.log("date: \(date.toString())")
        BQLogger.log("testDate: \(testDate.toString())")
        BQLogger.log("testDate1: \(testDate1.toString())")
        return ""
    }

    func testDate() {
        var components = DateComponents()
        components.year = 2023
        components.month = 3
        components.day = 15
        if let date = Calendar.current.date(from: components) {
            BQLogger.log("date: \(date)")
        }
    }
}
