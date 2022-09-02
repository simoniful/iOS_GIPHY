//
//  GIFs.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import CoreData

struct GIFs {
    let item: [GIFItem]
    let pagination: Pagination
}

struct GIFItem: Codable, Equatable {
    let type: String
    let id: String
    let webPageURL: String
    let title: String
    let images: GIFCategory
    let user: UserData
    let isFavorite: Bool

    static func == (lhs: GIFItem, rhs: GIFItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct GIFCategory: Codable {
    let original: GIFSize
    let preview: GIFSize
}

struct GIFSize: Codable {
    let height: String
    let width: String
    let size: String
    let url: String
}

struct UserData: Codable {
    let avatarURL: String
    let name: String
}

struct Pagination: Codable {
    let total: Int
    let count: Int
    let start: Int
}
