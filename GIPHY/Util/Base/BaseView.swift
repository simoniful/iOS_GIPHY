//
//  BaseView.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/18.
//

import UIKit

class BaseView: UIView, ViewRepresentable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure() {}
    func layout() {}
}
