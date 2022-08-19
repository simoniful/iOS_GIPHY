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
//
//    func pushDetailViewController(news: News, scrapedNews: ScrapedNews?) {
//        let vc = NewsWebViewController(
//            viewModel: NewsWebViewModel(
//                coordinator: self,
//                news: news,
//                scrapedNews: scrapedNews
//            )
//        )
//        vc.hidesBottomBarWhenPushed = true
//        navigationController.pushViewController(vc, animated: true)
//    }
//
//    func presentNewsTagmakerViewController(
//        tags: [String], newsTagmakerDelegate: NewsTagmakerDelegate
//    ) {
//        let vc = UINavigationController(
//            rootViewController: NewsTagmakerViewController(
//                viewModel: NewsTagmakerViewModel(
//                    coordinator: self,
//                    newsTagmakerDelegate: newsTagmakerDelegate,
//                    tags: tags
//                )
//            )
//        )
//        vc.modalPresentationStyle = .fullScreen
//        navigationController.present(vc, animated: true)
//    }
    
    func dismissToNewsListViewController(message: String? = nil) {
        navigationController.dismiss(animated: true) {
            if let message = message {
                self.navigationController.view.makeToast(message, position: .bottom)
            }
        }
    }
}
