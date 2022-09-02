//
//  CoreDataRepository.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/31.
//

import Foundation
import CoreData

final class DatabaseRepository: DatabaseRepositoryInterface {
    static let shared: DatabaseRepository = DatabaseRepository()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GIFCategory_CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return self.container.viewContext
    }

    func fetchData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    @discardableResult func saveGIFItem(item: GIFItem) -> Bool {
        do {
            let data = try JSONEncoder().encode(item)
            print( String(data: data, encoding: .utf8)! )
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = self.container.viewContext
            let itemData = try decoder.decode(GIFItem_CoreData.self, from: data)
            print("Received \(itemData) new commits.")
            
            if container.viewContext.hasChanges {
                do {
                    print ("Saved")
                    try container.viewContext.save()
                    return true
                } catch {
                    print("An error occurred while saving: \(error)")
                    return false
                }
            } else {
                return false
            }
        } catch {
            print(error)
            return false
        }
    }

    @discardableResult func deleteGIFItem(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
}
