//
//  GIFCategory_CoreData+CoreDataProperties.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/02.
//
//

import Foundation
import CoreData


extension GIFCategory_CoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GIFCategory_CoreData> {
        return NSFetchRequest<GIFCategory_CoreData>(entityName: "GIFCategory_CoreData")
    }

    @NSManaged public var gifItem: GIFItem_CoreData?
    @NSManaged public var preview: GIFSize_CoreData?
    @NSManaged public var original: GIFSize_CoreData?

}

extension GIFCategory_CoreData : Identifiable {}
