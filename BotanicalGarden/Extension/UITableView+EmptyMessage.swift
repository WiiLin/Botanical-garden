//
//  UITableView+EmptyMessage.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import SnapKit
import UIKit

extension UITableView {
    func setEmptyMessage(title: String, message: String, frame: CGRect) {
        let view = UIView(frame: bounds)
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .lightGray
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.sizeToFit()
        stackView.addArrangedSubview(titleLabel)

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.sizeToFit()
        stackView.addArrangedSubview(messageLabel)

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset((frame.height - bounds.height) / 2)
        }

        backgroundView = view
    }

    func restore() {
        backgroundView = nil
    }
}


