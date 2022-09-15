//
//  FileManager +.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/09/15.
//

import UIKit
import ImageIO
import MobileCoreServices
import Photos

extension FileManager {
    func createGIF(with images: [UIImage], name: URL, loopCount: Int = 0, frameDelay: Double) {
        let destinationURL = name
        let destinationGIF = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeGIF, images.count, nil)!

        let properties = [
            (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): frameDelay]
        ]

        for img in images {
            let cgImage = img.cgImage
            CGImageDestinationAddImage(destinationGIF, cgImage!, properties as CFDictionary?)
        }

        CGImageDestinationFinalize(destinationGIF)
    }
    
    func urlForFile(_ fileName: String, folderName: String? = nil) -> URL {
        var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if let folder = folderName {
            documentsDirectory = documentsDirectory.appendingPathComponent(folder)
            if !self.fileExists(atPath: documentsDirectory.path) {
                try? self.createDirectory(atPath: documentsDirectory.path, withIntermediateDirectories: true, attributes: nil)
            }
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return fileURL
    }
}
