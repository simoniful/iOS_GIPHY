//
//  SearchViewModel.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import RxSwift
import RxCocoa

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
    
    init(
        coordinator: SearchCoordinator?,
        searchUseCase: SearchUseCase
    ) {
        self.coordinator = coordinator
        self.searchUseCase = searchUseCase
    }
    
    struct Input {
        let search: Signal<String>
        let refreshSignal: Signal<Void>
        let prefetchRowsAt: Signal<[IndexPath]>
        let didSelectRowAt: Signal<GIFItem>
    }
    
    struct Output {
        let gifs: Driver<[GIFItem]>

    }
    
    let gifs = BehaviorRelay<[GIFItem]>(value: [])
    let search = BehaviorSubject(value: "")
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
