//
//  DatabaseRepositoryInterface.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/31.
//

import Foundation
import CoreData

protocol DatabaseRepositoryInterface {
    func fetchData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]
    @discardableResult func saveGIFItem(item: GIFItem) -> Bool
    @discardableResult func deleteGIFItem(object: NSManagedObject) -> Bool
}
