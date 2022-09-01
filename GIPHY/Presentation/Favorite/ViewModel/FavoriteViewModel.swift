//
//  FavoriteViewModel.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/31.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteViewModel: NSObject, ViewModel {
    var disposeBag = DisposeBag()
    
    weak var coordinator: FavoriteCoordinator?
    private let dataBaseUseCase: DataBaseUseCase
    
    init(
        coordinator: FavoriteCoordinator?,
        dataBaseUseCase: DataBaseUseCase = DataBaseUseCase(
            repository: DatabaseRepository.shared
        )
    ) {
        self.coordinator = coordinator
        self.dataBaseUseCase = dataBaseUseCase
    }
    
    struct Input {
        let didSelectRowAt: Signal<FavoritedGIFItem>
        let deleteForRowAt: Signal<IndexPath>
        let viewWillAppear: Signal<Void>
    }
    
    struct Output {
        let favoritedGifs: Driver<[FavoritedGIFItem]>
    }
    
    private let favoritedGifs = BehaviorRelay<[FavoritedGIFItem]>(value: [])
    
    func transform(input: Input) -> Output {
        return Output(favoritedGifs: favoritedGifs.asDriver())
    }
}
