//
//  SearchViewModel.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import RxSwift
import RxCocoa

enum CategoryStatus: Int {
    case gif
    case sticker
    case text
}

final class SearchViewModel: NSObject, ViewModel {
    var disposeBag = DisposeBag()
    
    weak var coordinator: SearchCoordinator?
    private let searchUseCase: SearchUseCase
    
    init(
        coordinator: SearchCoordinator?,
        searchUseCase: SearchUseCase
    ) {
        self.coordinator = coordinator
        self.searchUseCase = searchUseCase
    }
    
    struct Input {
        let didSelectRowAt: Signal<GIFItem>
        let rightBarButtonTapped: Signal<Void>
        let refreshSignal: Signal<Void>
        let prefetchRowsAt: Signal<[IndexPath]>
    }
    
    struct Output {
        let newsList: Driver<[GIFItem]>
        let showToastAction: Signal<String>
        let reloadTable: Signal<Void>
        let endRefreshing: Signal<Void>
        let scrollToTop: Signal<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
