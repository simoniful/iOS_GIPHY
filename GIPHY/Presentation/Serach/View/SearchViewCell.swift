//
//  SearchViewCell.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/24.
//

import UIKit

final class SearchViewCell: UICollectionViewCell, ViewRepresentable {
    static let identifier = "SearchViewCell"
    
    let cellView: ContentGIFView = {
        let view = ContentGIFView()
        view.layer.cornerRadius = 6.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(gifItem: GIFItem, indexPath: Int) {
        cellView.indicatorAction(bool: true)
        DispatchQueue.global().async { [weak self] in
            let image = UIImage.gifImageWithURL(gifItem.images.preview.url)
            DispatchQueue.main.async {
                self?.idLabel.text = "\(indexPath)"
                self?.cellView.imageView.image = image
                self?.cellView.indicatorAction(bool: false)
            }
        }
    }

    func configure() {
        contentView.addSubview(cellView)
        contentView.addSubview(idLabel)
    }
    
    func layout() {
        cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        idLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
}
