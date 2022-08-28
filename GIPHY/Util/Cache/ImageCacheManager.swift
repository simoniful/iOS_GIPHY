//
//  ImageCacheManager.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/28.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()

    private init() {}
}
