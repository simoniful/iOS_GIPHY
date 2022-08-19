//
//  BaseViewController.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/18.
//

import UIKit

class BaseViewController: UIViewController {

    let backBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "chevron.left")
        barButton.tintColor = .white
        return barButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationItem()

        backBarButton.target = self
        backBarButton.action = #selector(backButtonClicked)
    }

    func configureView() {}
    func configureNavigationItem() {}

    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
