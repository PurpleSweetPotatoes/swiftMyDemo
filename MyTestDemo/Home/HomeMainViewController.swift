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
    private var window: UIWindow?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tabBarName
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
        let alertVC = UIAlertController(title: "aaa", message: "bb", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "back", style: .cancel))
        print("-=-=-=: \(UIApplication.shared.connectedScenes)")
        navigationController?.present(alertVC, animated: true, completion: {
            print("-=-=-=: \(UIApplication.shared.connectedScenes)")
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
        
    }
}

final class TapFeedbackWindow: UIWindow {
    private var event: UIEvent?
    private var displayLink: CADisplayLink?
    private let tapView = UIView()

    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        clear()
        self.event = event
        resetDisplayLink()
        return nil
    }

    private func resetDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(eventProcessHandle))
        displayLink?.add(to: RunLoop.current, forMode: .common)
    }

    private func clearDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func clear() {
        event = nil
        clearDisplayLink()
        UIView.animate(withDuration: 0.15) {
            self.tapView.alpha = 0
        }
    }

    @objc private func eventProcessHandle() {
        guard let allTouches = self.event?.allTouches,
              !allTouches.isEmpty else {
            clear()
            return
        }
        if let touch = allTouches.first,
           let currentWindow = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last {
            let point = touch.location(in: currentWindow)
            switch touch.phase {
            case .began, .moved, .stationary:
                tapView.alpha = 1
                tapView.center = point
            default:
                UIView.animate(withDuration: 0.15) {
                    self.tapView.alpha = 0
                }
            }
        }
    }

    private func setupUI() {
        tapView.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        tapView.backgroundColor = UIColor(white: 0.7, alpha: 0.4)
        tapView.layer.cornerRadius = 20
        tapView.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.9, alpha: 0.5).cgColor
        tapView.layer.borderWidth = 2
        tapView.isUserInteractionEnabled = false
        tapView.clipsToBounds = true
        tapView.alpha = 0
        addSubview(tapView)
    }
}
