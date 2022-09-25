//
//  AppCoordinator.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/18.
//

import UIKit

final class AppCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .app

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func start() {
        connectTabBarFlow()
    }

    private func connectTabBarFlow() {
        let tabCoordinator = TabBarCoordinator(self.navigationController)
        tabCoordinator.delegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        finish()
    }
}
