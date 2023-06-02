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
//        TapFeedbackManager.share.feedbackEnable = true
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

struct TapFeedbackManager {
    static var share = TapFeedbackManager()

    var feedbackEnable: Bool = false {
        didSet {
            if feedbackEnable {
                UIApplication.exchangeSendEventMethod()
            }
        }
    }

    private lazy var feedbackView = Self.defaultFeedbackView()

    fileprivate static func receiveEvent(event: UIEvent, in window: UIWindow) {
        guard TapFeedbackManager.share.feedbackEnable else { return }
        let feedbackView = TapFeedbackManager.share.feedbackView
        if let touch = event.allTouches?.first,
           let currentWindow = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last {
            let point = touch.location(in: currentWindow)
            switch touch.phase {
            case .began,
                    .moved,
                    .stationary:
                if feedbackView != currentWindow {
                    feedbackView.removeFromSuperview()
                    currentWindow.addSubview(feedbackView)
                }
                feedbackView.center = point
            case .cancelled,
                    .ended:
                UIView.animate(withDuration: 0.15) {
                    feedbackView.alpha = 0
                } completion: { _ in
                    feedbackView.removeFromSuperview()
                    feedbackView.alpha = 1
                }
            default:
                break
            }
        }
    }

    private static func defaultFeedbackView() -> UIView {
        let tapFeedbackView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        tapFeedbackView.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
        tapFeedbackView.layer.cornerRadius = 20
        tapFeedbackView.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.9, alpha: 0.5).cgColor
        tapFeedbackView.layer.borderWidth = 2
        tapFeedbackView.isUserInteractionEnabled = false
        tapFeedbackView.clipsToBounds = true
        return tapFeedbackView
    }
}

fileprivate extension UIApplication {
    static func exchangeSendEventMethod() {
        DispatchQueue.once(token: "exchangeSendEventMethod") {
            let targetClass: AnyClass = Self.classForCoder()
            let originalSelector = #selector(sendEvent(_:))
            let swizzledSelector = #selector(exchangeSendEvent(_:))
            guard let originalMethod = class_getInstanceMethod(targetClass, originalSelector),
                  let swizzledMethod = class_getInstanceMethod(targetClass, swizzledSelector) else {
                return
            }
            let didAddMethod: Bool = class_addMethod(targetClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                class_replaceMethod(targetClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }

    @objc func exchangeSendEvent(_ event: UIEvent) {
        if let currentWindow = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last {
            TapFeedbackManager.receiveEvent(event: event, in: currentWindow)
        }
        exchangeSendEvent(event)
    }
}

extension AppDelegate {
    func testMethod() {
        let jsonDic: [String: Any] = [
            "request-id": "1875932",
            "requestee-name": "71d58c4f-87a7-4ba4-9621-154feba569bd",
            "profileImage-url": "https://s3.amazonaws.com/armin-connect-test/profile_images/4501d838-56db-44e3-b26d-48b70786d746-prfr.png",
            "aps": [
                "badge": 0,
                "alert": [
                    "loc-key": "pn_connection_request_message_format",
                    "title-loc-key": "pn_connection_request_title",
                    "loc-args": [
                        "Cheng"
                    ],
                    "mutable-content": 1
                ] as [String : Any]
            ] as [String : Any],
            "notification-key": "pushnotification_connection_request"
        ]
        APNSInfoHelper.add(jsonDic)
    }
}
