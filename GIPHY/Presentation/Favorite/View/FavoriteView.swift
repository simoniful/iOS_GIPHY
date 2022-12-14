//
//  FavoriteView.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/31.
//

import Foundation
import UIKit
import SnapKit

final class FavoriteView: BaseView {
    lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "No Datas Found"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func configure() {
        self.backgroundColor = .systemBackground
        [collectionView, noResultLabel].forEach {
            addSubview($0)
        }
    }
    
    override func layout() {
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(10.0)
            $0.top.equalTo(safeAreaLayoutGuide)
        }
        
        noResultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
}
