//
//  GIFs.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation

struct GIFs {
    let item: [GIFItem]
    let pagination: Pagination
}

struct GIFItem: Equatable {
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

struct GIFCategory {
    let original: GIFSize
    let preview: GIFSize
}

struct GIFSize {
    let height: String
    let width: String
    let size: String
    let url: String
}

struct UserData {
    let avatarURL: String
    let name: String
}

struct Pagination {
    let total: Int
    let count: Int
    let start: Int
}

extension GIFItem {
    init(favoritedGIFItem: FavoritedGIFItem) {
        self.type = favoritedGIFItem.
        self.id = favoritedGIFItem.id
        self.webPageURL = favoritedGIFItem.originalURL
        self.title
        self.images
        self.user
        self.isFavorite
    }
}
