//
//  BQNavigationViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/12.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit

class BQNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count > 1 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: viewController, action: #selector(popBackAction))
        }
    }
}

extension UIViewController {
    @objc func popBackAction() {
        navigationController?.popViewController(animated: true)
    }
}
