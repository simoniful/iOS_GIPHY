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
    }
    
    struct Input {
        let rightBarDownloadButtonTapped: Signal<Void>
        let rightBarBookmarkButtonTapped: Signal<Void>
        let gifLoaded: Signal<Void>
    }
    
    struct Output {
        let showToastAction: Signal<String>
        let indicatorAction: Driver<Bool>
        let savedState: Driver<Bool>
    }
    
    
    func transform(input: Input) -> Output {
        
        
        return Output()
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
