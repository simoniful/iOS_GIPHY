//
//  GIFSize_CoreData+CoreDataClass.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/02.
//
//

import Foundation
import CoreData

@objc(GIFSize_CoreData)
public class GIFSize_CoreData: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(height ?? "", forKey: .height)
            try container.encode(width ?? "", forKey: .width)
            try container.encode(size ?? "", forKey: .size)
            try container.encode(url ?? "", forKey: .url)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "GIFSize_CoreData", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            height = try values.decode(String.self, forKey: .height)
            width = try values.decode(String.self, forKey: .width)
            size = try values.decode(String.self, forKey: .size)
            url = try values.decode(String.self, forKey: .url)
        } catch {
            print ("error")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case height = "original"
        case width = "preview"
        case size = "size"
        case url = "url"
    }
}
