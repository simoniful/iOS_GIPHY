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

final class SearchViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let searchView = SearchView()
    private var viewModel: SearchViewModel
    // private lazy var input
    // private lazy var output
    
    private var searchController: UISearchController!
    
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
        
        navigationItem.title = "Search"
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = CategoryStatus.allCases.map{ $0.title }
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.showsScopeBar = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        print(selectedScope)
        // updateSearchResults(for: searchController)
    }
}

// MARK: - UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate { }

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}



