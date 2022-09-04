//
//  SearchCoordinator.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/18.
//

import UIKit
import Toast_Swift

final class SearchCoordinator: Coordinator {
    var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorStyleCase = .search
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SearchViewController(
            viewModel: SearchViewModel(
                coordinator: self,
                searchUseCase: SearchUseCase(
                    repository: GIPHYRepository()
                )
            )
        )
        navigationController.pushViewController(vc, animated: true)
    }

    func pushDetailViewController(item: GIFItem, savedItem: GIFItem_CoreData?) {
        let vc = DetailViewController(
            viewModel: DetailViewModel(
                coordinator: self,
                item: item,
                savedItem: savedItem
            )
        )
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func dismissToNewsListViewController(message: String? = nil) {
        navigationController.dismiss(animated: true) {
            if let message = message {
                self.navigationController.view.makeToast(message, position: .bottom)
            }
        }
    }
}
