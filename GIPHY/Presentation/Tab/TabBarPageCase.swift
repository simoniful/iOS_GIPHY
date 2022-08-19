//
//  TabBarPageCase.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/18.
//

import Foundation

enum TabBarPageCase: String, CaseIterable {
    case search, favorite

    init?(index: Int) {
        switch index {
        case 0: self = .search
        case 1: self = .favorite
        default: return nil
        }
    }

    var pageOrderNumber: Int {
        switch self {
        case .search: return 0
        case .favorite: return 1
        
        }
    }

    var pageTitle: String {
        switch self {
        case .search:
            return "Search"
        case .favorite:
            return "Favorite"
        }
    }

    func tabIconName() -> String {
        switch self {
        case .search:
            return "magnifyingglass"
        case .favorite:
            return "person"
        }
    }
}
