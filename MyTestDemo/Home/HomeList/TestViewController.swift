//
//  TestViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/13.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit
import BQSwiftKit
import Combine

class TestViewController: UIViewController {
    var storage = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.uiColor.backgroundDefaultColor
        testCombineButton()
    }

}

private extension TestViewController {
    func twoLabelTest() {
        let containerView = UIView()
        containerView.backgroundColor = .cyan
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview()
        }

        let leftLabel = UILabel()
        leftLabel.text = "多大事大多娜多娜几十年登记阿迪达斯大撒大声地"
        leftLabel.backgroundColor = .lightGray
        leftLabel.numberOfLines = 0
        leftLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        containerView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints {
            $0.leading.top.height.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        let rightLabel = UILabel()
        rightLabel.textAlignment = .right
        rightLabel.text = "341213fsdfsdfsfadasddfsdfsfsdf"
        rightLabel.backgroundColor = .orange
        rightLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        containerView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints {
            $0.trailing.top.height.equalToSuperview()
            $0.leading.equalTo(leftLabel.snp.trailing).offset(10)
        }
    }
}

private extension TestViewController {
    func testCombineButton() {
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 40))
        view.addSubview(label)
        let range = 4..<8
        _ = range.publisher.sink { element in
            print("-=-= :\(element)")
        }

        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 40))
        button.backgroundColor = .cyan
        button.setTitle("click", for: .normal)
        button.publisher(for: .touchUpInside).sink { button in
            print("button click")
            Task {
                print("thread: 按钮响应")
                await self.sleepFunction()
                print("task: completed")
            }
            print("button click completed")
        }.store(in: &storage)
        view.addSubview(button)
    }

    func sleepFunction() async {
        print("sleep: prepare sleep")
        Thread.sleep(forTimeInterval: 2)
        print("sleep: wake up")
    }
}

private extension TestViewController {
    func testLayerColor() {
        let useColor = UIColor(dark: UIColor("a6a6a6"), light: UIColor("6c6c6c"))
        let subView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 40))
        subView.layer.cornerRadius = 20
        subView.layer.borderWidth = 2
        subView.layer.borderColor = useColor.cgColor
        view.addSubview(subView)

        let compareView = UIView(frame: CGRect(x: 100, y: 200, width: 100, height: 40))
        compareView.backgroundColor = useColor
        view.addSubview(compareView)

        let layer = CALayer()
        layer.frame = CGRect(x: 100, y: 300, width: 100, height: 40)
        layer.borderWidth = 1
        layer.borderColor = useColor.cgColor
        layer.minificationFilter = .nearest
        layer.magnificationFilter = .nearest
        view.layer.addSublayer(layer)
    }
}
