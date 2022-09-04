//
//  DetailViewController.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/04.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let detailView = DetailView()
    private var viewModel: DetailViewModel
    
    private lazy var input = DetailViewModel.Input(

    )
    private lazy var output = viewModel.transform(input: input)
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(with: viewModel.item)
        bind()
    }
}

private extension DetailViewController {
    func setupNavigationBar(with item: GIFItem) {
        navigationItem.title = item.title
        navigationItem.rightBarButtonItems = [
            detailView.rightBarDownloadButton,
            detailView.rightBarBookmarkButton
        ]
    }
    
    func setupRightBarButton(with isBookmarked: Bool) {
        let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
        navigationItem.rightBarButtonItems?.last?.image = UIImage(systemName: imageName)
    }
    
    func bind() {
        
    }
}
