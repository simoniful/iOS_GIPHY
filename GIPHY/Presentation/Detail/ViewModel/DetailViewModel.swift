//
//  DetailViewModel.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/04.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

final class DetailViewModel: NSObject, ViewModel {
    var disposeBag = DisposeBag()
    
    weak var coordinator: Coordinator?
    private let dataBaseUseCase: DataBaseUseCase
    var item: GIFItem
    var savedItem: GIFItem_CoreData?
    
    private var savedGIFs: [GIFItem_CoreData] 
    
    init(
        coordinator: Coordinator?,
        dataBaseUseCase: DataBaseUseCase = DataBaseUseCase(
            repository: DatabaseRepository.shared
        ),
        item: GIFItem,
        savedItem: GIFItem_CoreData?
    ) {
        self.coordinator = coordinator
        self.dataBaseUseCase = dataBaseUseCase
        self.item = item
        self.savedItem = savedItem
        self.savedGIFs = dataBaseUseCase.fetchData(request: GIFItem_CoreData.fetchRequest())
    }
    
    struct Input {
        let rightBarDownloadButtonTapped: Signal<Void>
        let rightBarBookmarkButtonTapped: Signal<Void>
        let viewWillAppear: Signal<Void>
    }
    
    struct Output {
        let showToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
        let savedState: Driver<Bool>
    }
    
    private let showToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: true)
    private lazy var savedState = BehaviorRelay<Bool>(value: item.isFavorite)
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                let filterValue = self.savedGIFs.filter { $0.id == self.item.id }
                if filterValue.count >= 1 {
                    self.item.isFavorite = true
                    self.savedState.accept(self.item.isFavorite)
                    self.savedItem = filterValue.first
                }
            })
            .disposed(by: disposeBag)
        
        input.rightBarBookmarkButtonTapped
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.item.isFavorite.toggle()
                if self.item.isFavorite {
                    self.saveItem(item: self.item)
                } else {
                    guard let savedItem = self.savedItem else { return }
                    self.unsavedItem(savedItem: savedItem)
                }
                self.savedState.accept(self.item.isFavorite)
            })
            .disposed(by: disposeBag)
        
        return Output(
            showToastAction: showToastAction.asSignal(),
            indicatorAction: indicatorAction.asDriver(),
            savedState: savedState.asDriver()
        )
    }
}

private extension DetailViewModel {
    func saveItem(item: GIFItem) {
        dataBaseUseCase.saveGIFItem(item: item)
        let request: NSFetchRequest<GIFItem_CoreData> = GIFItem_CoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id CONTAINS %@", item.id)
        savedItem = dataBaseUseCase.fetchData(request: request).first
    }
    
    func unsavedItem(savedItem: GIFItem_CoreData) {
        dataBaseUseCase.deleteGIFItem(object: savedItem)
    }
}
