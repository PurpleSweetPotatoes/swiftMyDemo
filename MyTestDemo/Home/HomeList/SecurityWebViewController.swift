//
//  SecurityWebViewController.swift
//  MyTestDemo
//
//  Created by baipayne on 2025/2/28.
//

import UIKit
import SafariServices
import OSLog
import WebKit

class SecurityWebViewController: UIViewController {
    
    let logger = Logger(subsystem: "SecurityWebViewController", category: "test")

    let todoListOAuth = "https://todoist.com/oauth/authorize?client_id=0c541f84b0f04cf2ab8e359058beca8b&scope=data:read_write,data:delete,project:delete&state=1657407198&redirect_uri=https://connect.garmin.com/mobile-link/gcm/ciqApp/oauth&secureOAuth=true"
    let gcmDeepLink = "https://connect.garmin.com/mobile-link/gcm/ciqApp/oauth"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBtn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 40))
        navigationBtn.backgroundColor = .cyan
        navigationBtn.setTitle("Todo List OAuth", for: .normal)
        navigationBtn.addTarget(self, action: #selector(navigationBtnClick), for: .touchUpInside)
        view.addSubview(navigationBtn)
    }
 
    @objc
    func navigationBtnClick() {
        guard let url = URL(string: todoListOAuth) else {
            return
        }

        safariWebView(with: url)
    }
    
    func normalWebView(with url: URL) {
        let dataTypes = Set(
            [WKWebsiteDataTypeCookies,
             WKWebsiteDataTypeLocalStorage,
             WKWebsiteDataTypeSessionStorage]
        )
        logger.debug("safariViewController old web view")
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: Date.distantPast, completionHandler: {
            self.logger.debug("safariViewController remove completed")
            let webView = WKWebView(frame: self.view.bounds)
            webView.load(self.todoListOAuth)
            self.view.addSubview(webView)
        })
    }
    
    func safariWebView(with url: URL) {
        if #available(iOS 16.0, *) {
            SFSafariViewController.DataStore.default.clearWebsiteData {
                let safariVC = SFSafariViewController(url: url, configuration: SFSafariViewController.Configuration())
                safariVC.delegate = self
                self.present(safariVC, animated: true)
            }
        }
    }
}

extension SecurityWebViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        logger.debug("safariViewController DidFinish")
    }

    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        logger.debug("safariViewController didLoadSuccessfully")
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        Thread.sleep(forTimeInterval: 3)
        logger.debug("safariViewController initialLoadDidRedirectTo: \(URL.absoluteString)")
    }

    func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
        logger.debug("safariViewController activityItemsFor: \(URL.absoluteString)")
        return []
    }
}
