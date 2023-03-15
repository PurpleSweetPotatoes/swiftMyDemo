//
//  NormalInfoCell.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/12.
//  Copyright © 2023 Garmin All rights reserved
//  

import UIKit

protocol NormalInfoDataSource {
    var title: String { get }
    var content: String { get }
}

class NormalInfoCell: UITableViewCell {
    let titleLabel = UILabel()
    let contentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(_ model: NormalInfoDataSource) {
        titleLabel.text = model.title
        contentLabel.text = model.content
    }
}

private extension NormalInfoCell {
    func setupUI() {
        accessoryType = .disclosureIndicator

        titleLabel.font = ThemeManager.uiFont.body
        titleLabel.textColor = ThemeManager.uiColor.textDefaultColor
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }

        contentLabel.font = ThemeManager.uiFont.caption1
        contentLabel.textColor = ThemeManager.uiColor.textSecondColor
        contentLabel.numberOfLines = 0
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
}

struct NormalInfoModel: NormalInfoDataSource {
    var title: String
    var content: String
}
