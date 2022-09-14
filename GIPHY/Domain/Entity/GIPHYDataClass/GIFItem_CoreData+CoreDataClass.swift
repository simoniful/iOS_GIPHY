//
//  GIFItem_CoreData+CoreDataClass.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/02.
//
//

import Foundation
import CoreData

@objc(GIFItem_CoreData)
public class GIFItem_CoreData: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id ?? "", forKey: .id)
            try container.encode(type ?? "", forKey: .type)
            try container.encode(webPageURL ?? "", forKey: .webPageURL)
            try container.encode(title ?? "", forKey: .title)
            try container.encode(images, forKey: .images)
            try container.encode(user, forKey: .user)
            try container.encode(isFavorite, forKey: .isFavorite)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "GIFItem_CoreData", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            type = try values.decode(String.self, forKey: .type)
            id = try values.decode(String.self, forKey: .id)
            webPageURL = try values.decode(String.self, forKey: .webPageURL)
            title = try values.decode(String.self, forKey: .title)
            images = try values.decode(GIFCategory_CoreData.self, forKey: .images)
            user = try values.decode(UserData_CoreData.self, forKey: .user)
            isFavorite = try values.decode(Bool.self, forKey: .isFavorite)
        } catch {
            print ("error")
        }
    }
    
    func convertToGIFItem() -> GIFItem {
        return GIFItem(
            type: self.type!,
            id: self.id!,
            webPageURL: self.webPageURL!,
            title: self.title!,
            images: GIFCategory(
                original: GIFSize(
                    height: (self.images?.original?.height)!,
                    width: (self.images?.original?.width)!,
                    size: (self.images?.original?.size)!,
                    url: (self.images?.original?.url)!
                ),
                preview: GIFSize(
                    height: (self.images?.preview?.height)!,
                    width: (self.images?.preview?.width)!,
                    size: (self.images?.preview?.size)!,
                    url: (self.images?.preview?.url)!
                )
            ),
            user: UserData(
                avatarURL: (self.user?.avatarURL)!,
                name: (self.user?.name)!
            ),
            isFavorite: self.isFavorite
        )
    }

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case webPageURL = "webPageURL"
        case title = "title"
        case images = "images"
        case user = "user"
        case isFavorite = "isFavorite"
    }
}
