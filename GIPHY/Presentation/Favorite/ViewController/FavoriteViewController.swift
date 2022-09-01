//
//  FavoriteViewController.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class FavoriteViewController: UIViewController {
    private var disposeBag = DisposeBag()
    
    private let favoriteView = FavoriteView()

    private var viewModel: FavoriteViewModel
    
    private lazy var input = FavoriteViewModel.Input(
        didSelectRowAt: <#Signal<FavoritedGIFItem>#>,
        deleteForRowAt: <#Signal<IndexPath>#>,
        viewWillAppear: <#Signal<Void>#>
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
        
        guard let layout = favoriteView.collectionView.collectionViewLayout as? PinterestLayout else {
            return
        }
        layout.delegate = self

        output.favoritedGifs
            .drive(favoriteView.collectionView.rx.items) { collectionView, index, element in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCell.identifier, for: IndexPath(item: index, section: 0)) as? SearchViewCell else { return UICollectionViewCell()
                }
                // cell.setup(gifItem: element, indexPath: index)
                return cell
            }
            .disposed(by: disposeBag)
    }
}

extension FavoriteViewController: UICollectionViewDelegate { }

extension FavoriteViewController: PinterestLayoutDelegate {
    func numberOfItemsInCollectionView() -> Int {
        var count: Int = 0

        output.favoritedGifs
            .drive { gifs in
                count = gifs.count
            }
            .disposed(by: disposeBag)

        return count
    }

    func collectionView(_ collectionView: UICollectionView, RatioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        var computedRatio: CGFloat = 0

        output.favoritedGifs
            .drive { gifs in
                if !gifs.isEmpty {
//                    let width = (gifs[indexPath.item].images.preview.width as NSString).floatValue
//                    let height = (gifs[indexPath.item].images.preview.height as NSString).floatValue
//                    computedRatio = CGFloat(height / width)
                }
            }
            .disposed(by: self.disposeBag)

        return computedRatio
    }
}
