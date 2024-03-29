//
//  HomeMainViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/12.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit
import CoreLocation

enum HomeListType: CaseIterable {
    case testVC
    case webView
    case notificationTrigger
    case extensionList
    case dateRelated
    case heatMap
    case audioPrompts
    case appleMapTest
    case googleMapTest

    var dataSource: NormalInfoDataSource {
        switch self {
        case .extensionList:
            return NormalInfoModel(title: "Extension List", content: "Custom extension properties or methods")
        case .webView:
            return NormalInfoModel(title: "WebView Test", content: "use for test web view")
        case .testVC:
            return NormalInfoModel(title: "Test VC", content: "use for test method")
        case .notificationTrigger:
            return NormalInfoModel(title: "Create Push Notification", content: "quick and easy creation notification")
        case .dateRelated:
            return NormalInfoModel(title: "Date Related VC", content: "some date test & method")
        case .heatMap:
            return NormalInfoModel(title: "HeatMap Apple Map View", content: "custom apple heatMap")
        case .audioPrompts:
            return NormalInfoModel(title: "Audio Prompts VC", content: "play test")
        case .appleMapTest:
            return NormalInfoModel(title: "Apple Map View Test", content: "map test")
        case .googleMapTest:
            return NormalInfoModel(title: "Google Map View Test", content: "map test")
        }
    }

    var toViewController: UIViewController {
        var targetVC: UIViewController?
        switch self {
        case .extensionList:
            targetVC = ExtensionListViewController()
        case .webView:
            targetVC = BQWebViewController()
        case .testVC:
            targetVC = TestViewController()
        case .notificationTrigger:
            targetVC = NotificationTriggerViewController()
        case .dateRelated:
            targetVC = DateRelatedViewController()
        case .heatMap:
            targetVC = HeatMapTestViewController()
        case .audioPrompts:
            targetVC = AudioPromptsViewController()
        case .appleMapTest:
            targetVC = AppleMapTestViewController()
        case .googleMapTest:
            return GoogleMapViewController()
        }
        targetVC?.title = dataSource.title
        return targetVC ?? UIViewController()
    }
}

class HomeMainViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var dataList = HomeListType.allCases
    private var window: UIWindow?
    private let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(tabBarName)(\(UIApplication.isDebug ? "Debug" : "Normal"))"
        view.backgroundColor = .white
        setupUI()
        testMethod()
    }
    
}

private extension HomeMainViewController {
    func setupUI() {
        NormalInfoCell.register(to: tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "abc")
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
//        navigationController?.pushViewController(dataList[indexPath.row].toViewController, animated: true)

        Task {
            print("-=-=- start render")
            let result = await withUnsafeContinuation { [weak self] continuation in
                self?.startRender { str in
                    continuation.resume(returning: str)
                }
            }
            print("-=-=- \(result)")
        }
    }

    func startRender(handle: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            handle("abc")
        })
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "abc")
        headerView?.textLabel?.text = "asdbasd".uppercased()
        headerView?.textLabel?.font = ThemeManager.uiFont.body
        return headerView
    }
}

extension HomeMainViewController: TabBarInfoProtocol {
    var tabBarName: String {
        return "Demo"
    }
    var tabBarImage: UIImage? {
        return UIImage(systemName: "house")
    }

    func testMethod() {
        let englishLocale = Locale(identifier: "ZH_HK")
        if let english = (englishLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: "HK") {
            print("-=-=-=- english: \(english)")
        }
    }
}

extension HomeMainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locations)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}
