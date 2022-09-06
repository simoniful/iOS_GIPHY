//
//  FavoriteViewController.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/31.
//

import UIKit
import RxSwift
import RxCocoa


final class FavoriteViewController: UIViewController {
    private var disposeBag = DisposeBag()
    
    private let favoriteView = FavoriteView()

    private var viewModel: FavoriteViewModel
    
    private lazy var input = FavoriteViewModel.Input(
        didSelectRowAt: favoriteView.collectionView.rx.modelSelected(GIFItem_CoreData.self).asSignal(),
        viewWillAppear: self.rx.viewWillAppear.asSignal(),
        viewDidDisappear: self.rx.viewDidDisappear.asSignal()
    )
    
    lazy var output = viewModel.transform(input: input)
    
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = favoriteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bind()
    }
}

private extension FavoriteViewController {
    func setupNavigationBar() {
        navigationItem.title = "Favorite"
        definesPresentationContext = true
    }
    
    func bind() {
        favoriteView.collectionView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        guard let layout = favoriteView.collectionView.collectionViewLayout as? PinterestLayout else { return }
        layout.delegate = self

        output.favoritedGifs
            .drive(favoriteView.collectionView.rx.items) { collectionView, index, element in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: IndexPath(item: index, section: 0)) as? FavoriteCell else { return UICollectionViewCell()
                }
                cell.setup(gifItem: element, indexPath: index)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.updateLayout
            .emit(onNext: { _ in
                layout.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension FavoriteViewController: UICollectionViewDelegate { }

extension FavoriteViewController: PinterestLayoutDelegate {
    func numberOfItemsInCollectionView() -> Int {
        return viewModel.favoritedGifs.value.count
    }

    func collectionView(_ collectionView: UICollectionView, RatioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let gifs = viewModel.favoritedGifs.value
        guard let widthData = gifs[indexPath.item].images?.preview?.width else { return 0.75 }
        guard let heightData = gifs[indexPath.item].images?.preview?.height else { return 0.75 }
        let widthNum = (widthData as NSString).floatValue
        let heightNum = (heightData as NSString).floatValue
        let computedRatio = CGFloat(heightNum / widthNum)
        return computedRatio
    }
}
