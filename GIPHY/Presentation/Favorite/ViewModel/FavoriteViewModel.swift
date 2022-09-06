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
        let didSelectRowAt: Signal<GIFItem_CoreData>
        let viewWillAppear: Signal<Void>
        let viewDidDisappear: Signal<Void>
    }
    
    struct Output {
        let favoritedGifs: Driver<[GIFItem_CoreData]>
        let updateLayout: Signal<Void>
    }
    
    let favoritedGifs = BehaviorRelay<[GIFItem_CoreData]>(value: [])
    let updateLayout = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .emit(onNext: { [weak self] _ in
                self?.updateLayout.accept(())
                self?.requestGIFItems()
            })
            .disposed(by: disposeBag)
        
        input.viewDidDisappear
            .emit(onNext: { [weak self] _ in 
                self?.favoritedGifs.accept([])
            })
            .disposed(by: disposeBag)
        
        return Output(
            favoritedGifs: favoritedGifs.asDriver(),
            updateLayout: updateLayout.asSignal()
        )
    }
}

private extension FavoriteViewModel {
    func requestGIFItems() {
        let fetchedData = dataBaseUseCase.fetchData(request: GIFItem_CoreData.fetchRequest())
        favoritedGifs.accept(fetchedData)
    }
}
