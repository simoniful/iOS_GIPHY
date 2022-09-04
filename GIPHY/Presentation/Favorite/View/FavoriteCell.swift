//
//  FavoriteCell.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/02.
//

import UIKit

final class FavoriteCell: UICollectionViewCell, ViewRepresentable {
    static let identifier = "FavoriteCell"
    
    let cellView: ContentGIFView = {
        let view = ContentGIFView()
        view.layer.cornerRadius = 6.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(gifItem: GIFItem_CoreData, indexPath: Int) {
        cellView.indicatorAction(bool: true)
        DispatchQueue.global().async { [weak self] in
            guard let url = gifItem.images?.preview?.url else { return }
            let image = UIImage.gifImageWithURL(url)
            DispatchQueue.main.async {
                self?.cellView.imageView.image = image 
                self?.cellView.indicatorAction(bool: false)
            }
        }
    }

    func configure() {
        contentView.addSubview(cellView)
    }
    
    func layout() {
        cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
