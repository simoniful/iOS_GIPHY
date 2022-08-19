//
//  EndPoint.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import Alamofire

enum GIPHYAPI {
    case getGifData(query: String, start: Int, display: Int)
    case getStickerData(query: String, start: Int, display: Int)
    case getTextData(query: String, start: Int, display: Int)
}

extension GIPHYAPI {
    var url: URL {
        switch self {
        case .getGifData:
            return URL(string: "https://api.giphy.com/v1/gifs/search")!
        case .getStickerData:
            return URL(string: "https://api.giphy.com/v1/stickers/search")!
        case .getTextData:
            return URL(string: "https://api.giphy.com/v1/text/search")!
        }
    }

    var parameters: [String: String] {
        switch self {
        case .getGifData(let query, let start, let display):
            return getParameter(query: query, start: start, display: display)
        case .getStickerData(let query, let start, let display):
            return getParameter(query: query, start: start, display: display)
        case .getTextData(let query, let start, let display):
            return getParameter(query: query, start: start, display: display)
        }
    }

    var headers: HTTPHeaders {
        switch self {
        default:
            return [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }

    private func getParameter(query: String, start: Int, display: Int) -> [String: String] {
        return [
            "api_key": APIKey.apiKey,
            "q": query,
            "limit": "\(display)",
            "offset": "\(start)"
        ]
    }
}
