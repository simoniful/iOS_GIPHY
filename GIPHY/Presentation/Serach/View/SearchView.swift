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
        collectionView.backgroundColor = .black
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    override func configure() {
        
    }
    
    override func layout() {
        
    }
    
}
