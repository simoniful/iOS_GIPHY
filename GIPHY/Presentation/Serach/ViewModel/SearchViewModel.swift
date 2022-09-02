//
//  SearchViewModel.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import RxSwift
import RxCocoa
import Toast_Swift

final class SearchViewModel: NSObject, ViewModel {
    var disposeBag = DisposeBag()
    
    weak var coordinator: SearchCoordinator?
    private let searchUseCase: SearchUseCase
    
    private var totalCount = 0
    private var currentPage = 0
    private var display = 20
    
    init(
        coordinator: SearchCoordinator?,
        searchUseCase: SearchUseCase
    ) {
        self.coordinator = coordinator
        self.searchUseCase = searchUseCase
    }
    
    struct Input {
        let refreshSignal: Signal<Void>
        let prefetchItemsAt: Signal<[IndexPath]>
        let didSelectRowAt: Signal<GIFItem>
    }
    
    struct Output {
        let gifs: Driver<[GIFItem]>
        let reloadCollection: Signal<Void>
        let endRefreshing: Signal<Void>
        let showToastAction: Signal<String>
        let scrollToTop: Signal<Void>
    }
    
    let gifs = BehaviorRelay<[GIFItem]>(value: [])
    let searchKeyword = BehaviorSubject(value: "")
    let categoryStatus = BehaviorSubject(value: CategoryStatus.gif)
    
    let showToastAction = PublishRelay<String>()
    let reloadCollection = PublishRelay<Void>()
    let endRefreshing = PublishRelay<Void>()
    let scrollToTop = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        Observable.combineLatest(
            searchKeyword.asObservable()
                .filter { $0.count >= 3 }
                .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                .distinctUntilChanged(),
            categoryStatus
        )
        .subscribe(onNext: {[weak self] (query, style) in
            guard let self = self else { return }
            self.requestGifs(
                style: style,
                query: query,
                isNeededToReset: true
            )
        })
        .disposed(by: disposeBag)
        
        input.prefetchItemsAt
            .emit(onNext: { [weak self] indexPaths in
                guard let self = self else { return }
                for indexPath in indexPaths {
                    let limitIndex = self.gifs.value.count - 1
                    if indexPath.item == limitIndex && self.gifs.value.count < self.totalCount {
                        self.requestGifs(
                            style: try! self.categoryStatus.value(),
                            query: try! self.searchKeyword.value(),
                            isNeededToReset: false
                        )
                    }
                }

            })
            .disposed(by: disposeBag)
        
        return Output(
            gifs: gifs.asDriver(),
            reloadCollection: reloadCollection.asSignal(),
            endRefreshing: endRefreshing.asSignal(),
            showToastAction: showToastAction.asSignal(),
            scrollToTop: scrollToTop.asSignal()
        )
    }
}

private extension SearchViewModel {
    func requestGifs(
        style: CategoryStatus,
        query: String,
        isNeededToReset: Bool
    ) {
        if isNeededToReset {
            currentPage = 0
            totalCount = 0
            gifs.accept([])
        }
        searchUseCase.requestGIFs(
            style: style,
            query: query,
            start: (self.currentPage * self.display) + 1,
            display: self.display
        )
        .subscribe(
            onSuccess: {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let gifs):
                    let newValue = gifs.item
                    let oldValue = self.gifs.value
                    self.gifs.accept(oldValue + newValue)
                    self.currentPage += 1
                    self.totalCount = gifs.pagination.total
                    self.endRefreshing.accept(())
                    if isNeededToReset {
                        self.scrollToTop.accept(())
                        self.reloadCollection.accept(())
                    }
                case .error(let error):
                    self.showToastAction.accept(error.errorDescription)
                    self.gifs.accept([])
                }
            },
            onFailure: {[weak self] error in
                guard let self = self else { return }
                self.showToastAction.accept(error.localizedDescription)
                self.gifs.accept([])
            }
        )
        .disposed(by: self.disposeBag)
    }
}

enum CategoryStatus: Int, CaseIterable {
    case gif
    case sticker
    case text
    
    var title: String {
        switch self {
        case .gif:
            return "GIFs"
        case .sticker:
            return "Stickers"
        case .text:
            return "Text"
        }
    }
}


