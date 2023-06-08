//
//  BQWebViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/6/5.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit
import WebKit

class BQWebViewController: UIViewController {
    lazy var webView: WKWebView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let webView = WKWebView(frame: frame, configuration: WKWebView.getDeviceWidthWKWebViewConfiguration())
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        return webView
    }()

    var POST_JS: String {
            return """
            function my_post(action, params) {
                var method = \"POST\";
                var form = document.createElement(\"form\");
                form.setAttribute(\"method\", method);
                form.setAttribute(\"action\", action);
                for(var key in params) {
                    if (params.hasOwnProperty(key)) {
                        var hiddenFild = document.createElement(\"input\");
                        hiddenFild.setAttribute(\"type\", \"hidden\");
                        hiddenFild.setAttribute(\"name\", key);
                        hiddenFild.setAttribute(\"value\", params[key]);
                    }
                    form.appendChild(hiddenFild);
                }
                document.body.appendChild(form);
                form.submit();
            }
            """
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        view.addSubview(webView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "加载", style: .plain, target: self, action: #selector(loadRequest))
    }

    @objc func loadRequest() {
        let js = "function my_post(action, params) {\n    var method = \"POST\";\n    var form = document.createElement(\"form\");\n    form.setAttribute(\"method\", method);\n    form.setAttribute(\"action\", action);\n    for(var key in params) {\n        if (params.hasOwnProperty(key)) {\n            var hiddenFild = document.createElement(\"input\");\n            hiddenFild.setAttribute(\"type\", \"hidden\");\n            hiddenFild.setAttribute(\"name\", key);\n            hiddenFild.setAttribute(\"value\", params[key]);\n        }\n        form.appendChild(hiddenFild);\n    }\n    document.body.appendChild(form);\n    form.submit();\n}my_post(\"https://sso.garmin.cn/sso/socialSignIn?clientId=GarminConnectMobileiOS&generateExtraServiceTicket=true&mobile=true&source=https://sso.garmin.cn/sso/embed&gauthHost=https://sso.garmin.cn/sso&id=gauth-widget&service=https://sso.garmin.cn/sso/embed&embedWidget=true&locale=zh&redirectAfterAccountCreationUrl=https://sso.garmin.cn/sso/embed&cssUrl=https://static.garmin.cn/com.garmin.connect/ui/css/gcm-sso-theme-v1.7.css&redirectAfterAccountLoginUrl=https://sso.garmin.cn/sso/embed&locationPromptShown=true&showConnectLegalAge=true&showPrivacyPolicy=true&showTermsOfUse=true\", {\"loginProvider\":\"apple\",\"socialAccessToken\":\"ca3ad72a255134760b4781c1375af1c9b.0.rrut.TJstppv-IK4JBUclRZwWOA\",\"socialUserId\":\"000143.715fdf5ff6104ac791b41ac7c4835811.0719\"})"
        webView.evaluateJavaScript(js) { _, error in
            if let error = error {
                print("-=-=-=: 加载失败")
            } else {
                print("-=-=-=: 加载完成")
            }
        }
    }
}

extension WKWebView {
    class func getDeviceWidthWKWebViewConfiguration() -> WKWebViewConfiguration {
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let controller = WKUserContentController()
        controller.addUserScript(wkScript)
        let configure = WKWebViewConfiguration()
        configure.userContentController = controller
        return configure
    }
}
