//
//  ViewController.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let searchView = SearchView()
    private var viewModel: SearchViewModel
    private lazy var input
    private lazy var output
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}

