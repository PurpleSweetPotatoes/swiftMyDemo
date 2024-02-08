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
import SwiftUI

class TestViewController: UIViewController {
    var storage = Set<AnyCancellable>()
    deinit {
        print("deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addMoreXib()
    }
}

private extension TestViewController {
    class LabelCell: UITableViewCell {
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            createLabel()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func createLabel() {
            leftLabel.numberOfLines = 0
            leftLabel.font = ThemeManager.uiFont.body
            rightLabel.numberOfLines = 0
            rightLabel.textAlignment = .right
            contentView.addSubview(leftLabel)
            contentView.addSubview(rightLabel)

            leftLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(10)
                $0.top.equalToSuperview().offset(10)
                $0.bottom.equalToSuperview().offset(-10)
            }
            rightLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-10)
                $0.leading.equalTo(leftLabel.snp.trailing).offset(10)
                $0.width.equalTo(100)
                $0.centerY.equalToSuperview()
            }
        }

        func config() {
            let first = arc4random() % 2 == 0
            let second = arc4random() % 2 == 0
            leftLabel.text = first ? "啊实打实大大叔大婶" : "实打实大师大师大是的撒大萨达撒打撒"
//            rightLabel.text = second ? "0" : "123啊实打实大"
            rightLabel.text  = "\(Bundle.main.preferredLocalizations.first)"
        }
    }

    func reuseCellTest() {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        LabelCell.register(to: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)

        tableView.reloadData()
    }
}

private extension TestViewController {
    class CollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        class itemCell: UICollectionViewCell {
            override init(frame: CGRect) {
                super.init(frame: frame)
                let label = UILabel()
                label.text = "啊实打实大师大师"
                label.numberOfLines = 0
                addSubview(label)
                label.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                    $0.width.equalTo(50)
                    $0.height.greaterThanOrEqualTo(50)
                }
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setupUI() {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.estimatedItemSize = CGSize(width: 50, height: 50)
                layout.itemSize = UICollectionViewFlowLayout.automaticSize
            }
            contentView.addSubview(collectionView)
            itemCell.register(to: collectionView)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 8
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            itemCell.load(from: collectionView, indexPath: indexPath)
        }
    }

    func listWithCollectionViewUI() {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        UITableViewCell.register(to: tableView)
        CollectionCell.register(to: tableView)
        tableView.estimatedRowHeight = 200
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension TestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LabelCell.load(from: tableView, indexPath: indexPath)
        cell.config()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}

// combine
private extension TestViewController {
    func testPublish() {
        var cc = Set<AnyCancellable>()
        struct S {
            let p1: String
            let p2: String
        }
        [S(p1: "1", p2: "one"), S(p1: "2", p2: "two")]
            .publisher
            .print("array")
            .sink {
                print($0)
            }
            .store(in: &cc)
    }

    func testJust() {
        var cc = Set<AnyCancellable>()
        struct S {
            let p1: String
            let p2: String
        }

        let pb = Just(S(p1: "1", p2: "one"))
        pb
            .print("just")
            .sink {
                print("-0-\($0)")
            }
            .store(in: &cc)
    }

    func testPassthrough() {
        var cc = Set<AnyCancellable>()

        let pb = PassthroughSubject<String, Never>()

        let sb = pb
            .print("sb")
            // 会删除已经发送过的内容
            .removeDuplicates()
            // 会在订阅时先发送对应数据
            .prepend("a", "b")
            // five, six 会在completed后发送
            .append("five", "six")
            .sink {
                print($0)
            }

        sb.store(in: &cc)

        pb.send("one")
        pb.send("two")
        pb.send("three")
        pb.send("three")
        pb.send(completion: .finished)
    }

    func currentPublish() {
        var cc = Set<AnyCancellable>()

        // 会接受当前已配置的数据
        let cs = CurrentValueSubject<String, Never>("one")
        cs.send("two")
        cs.send("three")
        let sb1 = cs
            .print("cs sb1")
            .sink {
                print($0)
            }

        cs.send("four")
        cs.send("five")

        let sb2 = cs
            .print("cs sb2")
            .sink {
                print($0)
            }

        cs.send("six")

        sb1.store(in: &cc)
        sb2.store(in: &cc)
    }
}

private extension TestViewController {
    func testDate() {
        if let startDate = Date().startDayOfWeek,
           let nextSaturdayDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate) {
            print("本周开始:\(startDate)")
            print("本周六:\(nextSaturdayDate)")
            let inSameMonth = Calendar.current.isDate(startDate, equalTo: nextSaturdayDate, toGranularity: .month)
            print("是否同一个月: \(inSameMonth)")
        }

        for day in BQWeekDay.allCases {
            print("---\(Date().currentWeek(dayOfWeek: day))")
        }
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
//        leftLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        containerView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints {
            $0.leading.top.height.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        let rightLabel = UILabel()
        rightLabel.textAlignment = .right
        rightLabel.text = "341213fsdfsdfsfadasddfsdfsfsdf"
        rightLabel.backgroundColor = .orange
        rightLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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

private extension TestViewController {
    func stackViewTest() {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.backgroundColor = .randomColor
        stackView.frame = CGRect(x: 16, y: 100, width: view.sizeW - 32, height: 30)
        // [45.81216216087341, 79.05598640441895, 35.62187612056732, 45.515175461769104] 221.00520014762878
        let result = [45.81216216087341, 79.05598640441895, 35.62187612056732, 45.515175461769104].reduce(0) { partialResult, width in
            partialResult + width
        }
        let arr = [45.81216216087341, 129.13366324833711, 58.18640136492181, 74.34656890753229]
        let colors: [UIColor] = [.red, .green, .orange, .cyan]
        let texts: [String] = ["Round", "Jump Time", "Reps", "Speed"]
        for (index, width) in arr.enumerated() {
            let label = UILabel()
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.75
            label.numberOfLines = 0
            label.textAlignment = .right
            label.backgroundColor = colors[index]
            stackView.addArrangedSubview(label)
            label.snp.makeConstraints {
                $0.width.equalTo(width)
                $0.height.equalToSuperview()
            }
        }

//        stackView.addArrangedSubview(label)
//        let imageV = UIImageView()
//        imageV.backgroundColor = .red
//        stackView.addArrangedSubview(imageV)
//        imageV.snp.makeConstraints{
//            $0.width.equalTo(20)
//            $0.height.equalToSuperview()
//        }
//        let spacingV = UIView()
//        stackView.addArrangedSubview(spacingV)
//        spacingV.snp.makeConstraints{
//            $0.width.equalTo(5)
//            $0.height.equalToSuperview()
//        }
//            view.snp.makeConstraints {
//                $0.width.equalTo(width)
//                $0.height.equalToSuperview()
//            }
//        }
        view.addSubview(stackView)
    }
}

private extension TestViewController {
    func addMoreXib() {
        if let firstView = TestMoreXibView.loadView(type: .first) {
            firstView.frame = CGRect(x: 0, y: 100, width: view.sizeW, height: 100)
            view.addSubview(firstView)
        }

        if let secondView = TestMoreXibView.loadView(type: .last) {
            secondView.frame = CGRect(x: 0, y: 200, width: view.sizeW, height: 100)
            view.addSubview(secondView)
        }
    }
}
