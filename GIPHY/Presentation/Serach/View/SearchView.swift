//
//  SearchView.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import UIKit
import SnapKit

final class SearchView: BaseView {
    lazy var collectionView: UICollectionView = {
        let layout = PinterestLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: SearchViewCell.identifier)
        // collectionView.backgroundColor = .black
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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    override func configure() {
        [collectionView, noResultLabel].forEach {
            addSubview($0)
        }
    }
    
    override func layout() {
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16.0)
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        noResultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
}
