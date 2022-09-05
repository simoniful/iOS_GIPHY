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
    private var searchController = UISearchController(searchResultsController: nil)
    private var viewModel: SearchViewModel
    
    private lazy var input = SearchViewModel.Input(
        prefetchItemsAt: searchView.collectionView.rx.prefetchItems.asSignal(),
        didSelectRowAt: searchView.collectionView.rx.modelSelected(GIFItem.self).asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
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
        setupNavigationBar()
        bind()
    }
}

private extension SearchViewController {
    func setupNavigationBar() {
        navigationItem.title = "Search"
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = CategoryStatus.allCases.map{ $0.title }
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.showsScopeBar = true
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func bind() {
        searchView.collectionView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
             
        output.gifs
            .drive(searchView.collectionView.rx.items) { collectionView, index, element in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCell.identifier, for: IndexPath(item: index, section: 0)) as? SearchViewCell else { return UICollectionViewCell()
                }
                cell.setup(gifItem: element, indexPath: index)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.reloadCollection
            .emit(onNext: { [weak self] _ in
                self?.searchView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            viewModel.categoryStatus.onNext(CategoryStatus.gif)
        case 1:
            viewModel.categoryStatus.onNext(CategoryStatus.sticker)
        case 2:
            viewModel.categoryStatus.onNext(CategoryStatus.text)
        default:
            viewModel.categoryStatus.onNext(CategoryStatus.gif)
        }
    }
}

// MARK: - UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate { }

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchKeyword.onNext(searchController.searchBar.text ?? "")
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    
}







