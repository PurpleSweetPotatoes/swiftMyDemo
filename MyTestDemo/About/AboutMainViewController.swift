//
//  AboutMainViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/12.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit

class AboutMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarName
        view.backgroundColor = .white
    }
    
}

extension AboutMainViewController: TabBarInfoProtocol {
    var tabBarName: String {
        return "About"
    }
    var tabBarImage: UIImage? {
        return UIImage(systemName: "ellipsis.circle")
    }
}
