//
//  NetworkError.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation

enum NetworkError: Int, Error {
    case badRequest = 400
    case forbidden = 403
    case notFoundData = 404
    case tooLongQuery = 414
    case tooManyRequest = 429
    case noNetwork = 500
}

extension NetworkError {
    var errorDescription: String {
        switch self {
        case .badRequest: return "잘못된 요청입니다"
        case .forbidden: return "권한이 없습니다"
        case .notFoundData: return "데이터를 찾을 수 없습니다"
        case .tooLongQuery: return "50글자 이하로 작성해주세요"
        case .tooManyRequest: return "잠시 후 다시 시도해주세요"
        case .noNetwork: return "네트워크 연결을 확인해주세요"
        }
    }
}
