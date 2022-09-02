//
//  UserData_CoreData+CoreDataProperties.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/02.
//
//

import Foundation
import CoreData


extension UserData_CoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData_CoreData> {
        return NSFetchRequest<UserData_CoreData>(entityName: "UserData_CoreData")
    }

    @NSManaged public var avatarURL: String?
    @NSManaged public var name: String?
    @NSManaged public var gifItem: GIFItem_CoreData?

}

extension UserData_CoreData : Identifiable {}
