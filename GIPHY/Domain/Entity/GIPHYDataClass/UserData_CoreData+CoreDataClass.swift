//
//  UserData_CoreData+CoreDataClass.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/02.
//
//

import Foundation
import CoreData

@objc(UserData_CoreData)
public class UserData_CoreData: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(name ?? "", forKey: .name)
            try container.encode(avatarURL ?? "", forKey: .avatarURL)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "UserData_CoreData", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            avatarURL = try values.decode(String.self, forKey: .avatarURL)
            name = try values.decode(String.self, forKey: .name)
        } catch {
            print ("error")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatarURL"
        case name = "name"
    }
}
