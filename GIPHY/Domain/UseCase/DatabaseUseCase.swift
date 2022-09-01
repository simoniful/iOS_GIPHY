//
//  DatabaseUseCase.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/31.
//

import Foundation
import CoreData

final class DataBaseUseCase {
    let repository: DatabaseRepositoryInterface

    init(repository: DatabaseRepositoryInterface) {
        self.repository = repository
    }

    func fetchData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        repository.fetchData(request: request)
    }
    
    @discardableResult func saveGIFItem(item: GIFItem) -> Bool {
        repository.saveGIFItem(item: item)
    }
    
    @discardableResult func deleteGIFItem(object: NSManagedObject) -> Bool {
        repository.deleteGIFItem(object: object)
    }
}
