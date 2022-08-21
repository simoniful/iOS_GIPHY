//
//  TabCoordinator.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/18.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var type: CoordinatorStyleCase = .tab

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
        self.tabBarController = UITabBarController()
    }

    func start() {
        let pages: [TabBarPageCase] = TabBarPageCase.allCases
        let controllers: [UINavigationController] = pages.map({
            self.createTabNavigationController(of: $0)
        })
        self.configureTabBarController(with: controllers)
    }

    func currentPage() -> TabBarPageCase? {
        TabBarPageCase(index: self.tabBarController.selectedIndex)
    }

    func selectPage(_ page: TabBarPageCase) {
        self.tabBarController.selectedIndex = page.pageOrderNumber
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPageCase(index: index) else { return }
        self.tabBarController.selectedIndex = page.pageOrderNumber
    }

    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPageCase.search.pageOrderNumber
        self.changeAnimation()
        self.navigationController.pushViewController(tabBarController, animated: true)
    }

    private func configureTabBarItem(of page: TabBarPageCase) -> UITabBarItem {
        return UITabBarItem(
            title: page.pageTitle,
            image: UIImage(systemName: page.tabIconName()),
            selectedImage: UIImage(systemName: page.tabIconName() + ".fill")
        )
    }

    private func createTabNavigationController(of page: TabBarPageCase) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
        connectTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }

    private func connectTabCoordinator(of page: TabBarPageCase, to tabNavigationController: UINavigationController) {
        switch page {
        default:
            let searchCoordinator = SearchCoordinator(tabNavigationController)
            searchCoordinator.delegate = self
            self.childCoordinators.append(searchCoordinator)
            searchCoordinator.start()
//        case .favorite:
//            let favoriteCoordinator = FavoriteCoordinator(tabNavigationController)
//            favoriteCoordinator.delegate = self
//            self.childCoordinators.append(favoriteCoordinator)
//            favoriteCoordinator.start()
        }
    }
}

extension TabBarCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        self.delegate?.didFinish(childCoordinator: self)
    }
}
