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
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerNotification()
        BQLogger.log(UIApplication.isDebug ? "current environment is Debug" : "current environment is Release")
        application.registerForRemoteNotifications()
        UIViewController.startLifeCyclingLog()
        GMSServices.setAbnormalTerminationReportingEnabled(false)
        GMSServices.setMetalRendererEnabled(false)
        GMSServices.provideAPIKey("AIzaSyDpi2zD8sEwKqMhPSK2s_Qb1Cfm-X-Z3fs")
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
                BQLogger.log("同意")
            } else {
                BQLogger.warning("拒绝")
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
        return [.sound, .badge]
    }
}

import MapKit

class ClimbPolyLine: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var boundingMapRect: MKMapRect = MKMapRect()
    var zPosition: Int
    init(_ zPosition: Int) {
        self.zPosition = zPosition
    }
}

class NormalPolyLine: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var boundingMapRect: MKMapRect = MKMapRect()
    var zIndex: Int
    init(_ zIndex: Int) {
        self.zIndex = zIndex
    }
}

extension AppDelegate {
    func testMethod() {
        let array: [MKOverlay] = [
            NormalPolyLine(5),
            NormalPolyLine(1),
            ClimbPolyLine(2),
            ClimbPolyLine(1),
            ClimbPolyLine(3),
            NormalPolyLine(4),
        ]
        let climbPolylines = array.compactMap { $0 as? ClimbPolyLine}
        let otherOverlays = array.filter { !($0 is ClimbPolyLine) }
        let sortedClimbPolylines = climbPolylines.sorted {
            $0.zPosition < $1.zPosition
        }
        let sortedOverlays: [MKOverlay] = sortedClimbPolylines + otherOverlays
        print("-=-=- sorted: \(sortedOverlays)")
        for index in 0..<array.count {
            let oldOverly = array[index]
            let newOverly = sortedOverlays[index]
            if oldOverly.coordinate.latitude != newOverly.coordinate.latitude,
               oldOverly.coordinate.longitude != newOverly.coordinate.longitude,
               !MKMapRectEqualToRect(oldOverly.boundingMapRect, newOverly.boundingMapRect) {
                print("不等 刷新")
                return
            }
        }
    }
}
