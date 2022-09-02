//
//  GIFSize_CoreData+CoreDataProperties.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/02.
//
//

import Foundation
import CoreData


extension GIFSize_CoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GIFSize_CoreData> {
        return NSFetchRequest<GIFSize_CoreData>(entityName: "GIFSize_CoreData")
    }

    @NSManaged public var height: String?
    @NSManaged public var size: String?
    @NSManaged public var url: String?
    @NSManaged public var width: String?
    @NSManaged public var preview: GIFCategory_CoreData?
    @NSManaged public var original: GIFCategory_CoreData?

}

extension GIFSize_CoreData : Identifiable {}
