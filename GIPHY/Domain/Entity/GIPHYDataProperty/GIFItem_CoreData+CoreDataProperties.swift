//
//  GIFItem_CoreData+CoreDataProperties.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/02.
//
//

import Foundation
import CoreData


extension GIFItem_CoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GIFItem_CoreData> {
        return NSFetchRequest<GIFItem_CoreData>(entityName: "GIFItem_CoreData")
    }

    @NSManaged public var type: String?
    @NSManaged public var id: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var webPageURL: String?
    @NSManaged public var title: String?
    @NSManaged public var user: UserData_CoreData?
    @NSManaged public var images: GIFCategory_CoreData?

}

extension GIFItem_CoreData : Identifiable {}
