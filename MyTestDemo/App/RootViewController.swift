//
//  RootViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/12.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit
import BQSwiftKit

class RootTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension RootTabBarViewController {
    func setupUI() {
        let vcList: [TabBarInfoProtocol] = [
            HomeMainViewController(),
            AboutMainViewController()
        ]
        viewControllers = vcList.map { $0.configTabBarInfo() }
    }
}

protocol TabBarInfoProtocol {
    var tabBarName: String { get }
    var tabBarImage: UIImage? { get }
    func configTabBarInfo() -> UIViewController
}

extension TabBarInfoProtocol where Self: UIViewController {
    func configTabBarInfo() -> UIViewController {
        let configItem = UITabBarItem(title: tabBarName,
                                      image: tabBarImage, selectedImage: tabBarImage)
        tabBarItem = configItem
        return BQNavigationViewController(rootViewController: self)
    }
}

