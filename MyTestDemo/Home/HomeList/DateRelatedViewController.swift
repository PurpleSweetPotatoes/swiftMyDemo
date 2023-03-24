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
        BQLogger.log(testMethod())
    }

    func testMethod() -> String {
        let nowDate = Date()
        BQLogger.log("nowDate: \(nowDate.components)")
        let testDateString = "2023-03-23 15:59:46"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let testDate = formatter.date(from: testDateString) {
            BQLogger.log("testDate: \(testDate.components)")
            let range = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year, .era], from: testDate, to: nowDate)
            guard testDate <= nowDate,
                  let second = range.second,
                  let minute = range.minute,
                  let hour = range.hour,
                  let day = range.day,
                  let month = range.month,
                  let year = range.year else {
                return "转化失败"
            }

            BQLogger.log("second: \(second) -- minute: \(minute) -- hour: \(hour) -- day: \(day) -- month: \(month) -- year: \(year)")
            // 1-59 secs ago
            if abs(second) < 60 && minute == 0 && hour == 0 && day == 0 && month == 0 && year == 0 {
                return "1分钟内"
            }
            // 1-59 mins ago
            if abs(minute) < 60 && hour == 0 && day == 0 && month == 0 && year == 0 {
                return "1小时内"
            }
            // 1-24 hours ago
            if abs(hour) < 24 && day == 0 && month == 0 && year == 0 {
                return "1天内"
            }
            // 1-2 days ago
            if day < 2 && month == 0 && year == 0 {
                return "2天内"
            }
            // 2-7 days ago
            if day < 7 && month == 0 && year == 0 {
                return "7天内"
            }
            // more 7 days is same year
            if testDate.components.year == nowDate.components.year {
                return "同一年"
            }
            // priorYear
            return "今年前"
        }
        return "获取时间失败"
    }
}
