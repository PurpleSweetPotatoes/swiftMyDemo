//
//  AppDelegate.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/10.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit
import UserNotifications
import BQSwiftKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerNotification()
        application.registerForRemoteNotifications()
        testMethod()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerNotification() {
        BQLogger.log("开始注册")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("同意")
            } else {
                print("拒绝")
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BQLogger.log("获取到deviceToken: \(deviceToken.hexStr)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        BQLogger.error("获取到deviceToken 失败: \(error.localizedDescription)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        BQLogger.log("did Receive: \(response.notification.request.content)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        BQLogger.log("will present: \(notification.request.content)")
        return [.alert, .sound, .badge]
    }
}

extension AppDelegate {
    func testMethod() {
        let dateUntil = CalendarDateUntil()
        let currentList = dateUntil.currentMonthList()
        print(currentList)
    }
}

struct CalendarDate {
    // The value is like 202201
    let shortYearMonth: Int
    let date: Date
    let isCurrentMonth: Bool
}

struct CalendarDateUntil {
    private let calendar = Calendar.current

    func currentMonthList() -> [CalendarDate] {
        let currentDate = Date()
        guard let fromDate = currentDate.startDayOfMonth?.currentWeek(dayOfWeek: .sunday),
              let endDate = currentDate.endDayOfMonth?.currentWeek(dayOfWeek: .saturday) else {
            return []
        }

        let components = currentDate.components
        let shortYearMonth = (components.year ?? 0) * 100 + (components.month ?? 0)
        var outList: [CalendarDate] = [CalendarDate(shortYearMonth: shortYearMonth, date: fromDate, isCurrentMonth: fromDate.components.month == currentDate.components.month)]
        calendar.enumerateDates(startingAfter: fromDate, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) { date, exactMatch, stop in
            guard let date = date else {
                stop = true
                return
            }
            if date > endDate {
                stop = true
            } else {
                outList.append(CalendarDate(shortYearMonth: shortYearMonth, date: date, isCurrentMonth: date.components.month == currentDate.components.month))
            }
        }
        return outList
    }
}
