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

struct GIFItem {
    let type: String
    let id: String
    let webPageURL: String
    let title: String
    let images: GIFCategory
    let user: UserData
    let isFavorite: Bool
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