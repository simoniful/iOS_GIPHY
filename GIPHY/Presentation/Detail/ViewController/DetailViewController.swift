//
//  DetailViewController.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/04.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class DetailViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let detailView = DetailView()
    private var viewModel: DetailViewModel
    
    private lazy var input = DetailViewModel.Input(
        rightBarDownloadButtonTapped: detailView.rightBarDownloadButton.rx.tap.asSignal(),
        rightBarBookmarkButtonTapped: detailView.rightBarBookmarkButton.rx.tap.asSignal()
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
    
    override func viewWillAppear(_ animated: Bool) {
        contentViewConfigByItem(
            item: self.viewModel.item,
            savedItem: self.viewModel.savedItem
        )
        super.viewWillAppear(animated)
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
    
    private func contentViewConfigByItem(
        item: GIFItem,
        savedItem: GIFItem_CoreData?
    ) {
        if savedItem == nil {
            updateContentView(
                avatar: item.user.avatarURL,
                gif: item.images.original.url,
                name: item.user.name,
                height: item.images.original.height,
                isFavorite: item.isFavorite
            )
        } else {
            
        }
    }
    
    private func updateContentView(
        avatar: String,
        gif: String,
        name: String,
        height: String,
        isFavorite: Bool
    ) {
        let height: Int32 = Int32(height) ?? 0
        detailView.contentView.indicatorAction(bool: true)
        detailView.userImageView.setImageUrl(avatar)
        detailView.userNameLabel.text = name
        detailView.contentView.snp.makeConstraints {
            $0.height.equalTo(CGFloat(height))
        }
        detailView.scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: CGFloat(height) + 100
        )

        DispatchQueue.main.async { [weak self] in
            self?.detailView.contentView.imageView.image = UIImage.gifImageWithURL(gif)
            self?.detailView.contentView.indicatorAction(bool: false)
        }
    }
}
