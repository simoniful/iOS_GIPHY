//
//  ContentGIFView.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/27.
//
import UIKit

final class ContentGIFView: BaseView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .white
        indicatorView.backgroundColor = .black
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func configure() {
        [imageView, indicatorView].forEach {
            addSubview($0)
        }
    }

    override func layout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func indicatorAction(bool: Bool) {
        if bool {
            indicatorView.isHidden = false
            indicatorView.startAnimating()
        } else {
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
        }
    }
}
