//
//  GIFCategory_CoreData+CoreDataClass.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/02.
//
//

import Foundation
import CoreData

@objc(GIFCategory_CoreData)
public class GIFCategory_CoreData: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(original, forKey: .original)
            try container.encode(preview, forKey: .preview)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "GIFCategory_CoreData", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            original = try values.decode(GIFSize_CoreData.self, forKey: .original)
            preview = try values.decode(GIFSize_CoreData.self, forKey: .preview)
        } catch {
            print ("error")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case original = "original"
        case preview = "preview"
    }
}
