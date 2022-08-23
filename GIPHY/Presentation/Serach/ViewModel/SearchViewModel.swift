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
        let prefetchRowsAt: Signal<[IndexPath]>
        let didSelectRowAt: Signal<GIFItem>
    }
    
    struct Output {
        let gifs: Driver<[GIFItem]>
        let reloadTable: Signal<Void>
        let endRefreshing: Signal<Void>
        let showToastAction: Signal<String>
        let scrollToTop: Signal<Void>
    }
    
    let gifs = BehaviorRelay<[GIFItem]>(value: [])
    let searchKeyword = BehaviorSubject(value: "")
    let categoryStatus = BehaviorSubject(value: CategoryStatus.gif)
    
    let showToastAction = PublishRelay<String>()
    let reloadTable = PublishRelay<Void>()
    let endRefreshing = PublishRelay<Void>()
    let scrollToTop = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        Observable.combineLatest(
            searchKeyword.asObservable()
                .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                .distinctUntilChanged(),
            categoryStatus
        )
        .subscribe(onNext: {[weak self] (query, style) in
            guard let self = self else { return }
            self.searchUseCase.requestGIFs(
                style: style,
                query: query,
                start: self.currentPage,
                display: self.display
            )
            .subscribe(
                onSuccess: {[weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let gifs):
                        self.gifs.accept(gifs.item)
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
        })
        .disposed(by: disposeBag)
        
        return Output(
            gifs: gifs.asDriver(),
            reloadTable: reloadTable.asSignal(),
            endRefreshing: endRefreshing.asSignal(),
            showToastAction: showToastAction.asSignal(),
            scrollToTop: scrollToTop.asSignal()
        )
    }
}


