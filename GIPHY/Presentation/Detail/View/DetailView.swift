//
//  DetailView.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/04.
//

import UIKit
import SnapKit

final class DetailView: BaseView {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var rightBarDownloadButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "square.and.arrow.down")
        barButton.style = .plain
        return barButton
    }()
    
    lazy var rightBarBookmarkButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "bookmark")
        barButton.style = .plain
        return barButton
    }()
    
    lazy var contentView: ContentGIFView = {
        let view = ContentGIFView()
        view.imageView.contentMode = .center
        view.imageView.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configure() {
        self.backgroundColor = .systemBackground
        
        addSubview(scrollView)
        
        [contentView, userImageView, userNameLabel].forEach {
            scrollView.addSubview($0)
        }
    }
    
    override func layout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10.0)
            $0.width.equalTo(UIScreen.main.bounds.width - 20.0)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().offset(10.0)
            $0.width.height.equalTo(50.0)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView.snp.centerY)
            $0.leading.equalTo(userImageView.snp.trailing).offset(10.0)
            $0.trailing.equalToSuperview().offset(10.0)
        }
    }
}

