//
//  NotificationTriggerViewController.swift
//  MyTestDemo
//
//  Created by Bai, Payne on 2023/3/22.
//  Copyright © 2023 Garmin All rights reserved
//

import Combine
import UIKit
import UserNotifications
import BQSwiftKit

class NotificationTriggerViewController: UIViewController {
    private var storage = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupUI()
    }

}

private extension NotificationTriggerViewController {
    func setupUI() {
        let sendButton = UIButton()
        sendButton.setTitle("Send notification", for: .normal)
        sendButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            self?.sendNotification()
        }.store(in: &storage)
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(40)
            $0.center.equalToSuperview()
        }
    }

    @objc
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "My Test Demo Tip"
        content.body = "abcd"
        content.userInfo = [
            "mutable-content": 1
        ]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "com.garmin.baipayne.MyTestDemo", content: content, trigger: trigger)) { error in
            if let error = error {
                BQLogger.error("notification send error: \(error.localizedDescription)")
            }
            BQLogger.log("notification send completed")
        }
    }
}
