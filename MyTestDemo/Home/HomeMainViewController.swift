//
//  HomeMainViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/12.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit

enum HomeListType: CaseIterable {
    case testVC
    case notificationTrigger
    case extensionList
    case dateRelated

    var dataSource: NormalInfoDataSource {
        switch self {
        case .extensionList:
            return NormalInfoModel(title: "Extension List", content: "Custom extension properties or methods")
        case .testVC:
            return NormalInfoModel(title: "Test VC", content: "use for test method")
        case .notificationTrigger:
            return NormalInfoModel(title: "Create Push Notification", content: "quick and easy creation notification")
        case .dateRelated:
            return NormalInfoModel(title: "Date Related VC", content: "some date test & method")
        }
    }

    var toViewController: UIViewController {
        var targetVC: UIViewController?
        switch self {
        case .extensionList:
            targetVC = ExtensionListViewController()
        case .testVC:
            targetVC = TestViewController()
        case .notificationTrigger:
            targetVC = NotificationTriggerViewController()
        case .dateRelated:
            targetVC = DateRelatedViewController()
        }
        targetVC?.title = dataSource.title
        return targetVC ?? UIViewController()
    }
}

class HomeMainViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var dataList = HomeListType.allCases
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarName
        view.backgroundColor = .white
        setupUI()
    }
    
}

private extension HomeMainViewController {
    func setupUI() {
        NormalInfoCell.register(to: tableView)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HomeMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NormalInfoCell.load(from: tableView, indexPath: indexPath)
        cell.config(dataList[indexPath.row].dataSource)
        return cell
    }
}

extension HomeMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(dataList[indexPath.row].toViewController, animated: true)
    }
}

extension HomeMainViewController: TabBarInfoProtocol {
    var tabBarName: String {
        return "Demo"
    }
    var tabBarImage: UIImage? {
        return UIImage(systemName: "house")
    }
}
