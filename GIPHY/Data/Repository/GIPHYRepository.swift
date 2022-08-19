//
//  GIPHYRepository.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import RxSwift
import RxAlamofire

final class GIPHYRepository: GIPHYRepositoryInterface {
    private let disposeBag = DisposeBag()

    func requestGIFs(
        style: CategoryStatus,
        query: String,
        start: Int,
        display: Int
    ) async throws -> GIFs {
        var giphyAPI: GIPHYAPI = .getGifData(query: query, start: start, display: display)

        switch style {
        case .gif:
            giphyAPI = .getGifData(query: query, start: start, display: display)
        case .sticker:
            giphyAPI = .getStickerData(query: query, start: start, display: display)
        case .text:
            giphyAPI = .getTextData(query: query, start: start, display: display)
        }

        // RxAlamofire
        return try await withCheckedThrowingContinuation({ continuation in
            let a = requestJSON(.get, giphyAPI.url, parameters: giphyAPI.parameters, headers: giphyAPI.headers)
                .map { $1 }
                .map { response -> GIFs in
                    let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                    let productListData = try JSONDecoder().decode(GIFSearchResponseDTO.self, from: data)
                    return productListData.toEntity()
                }
                
                

            
            
//            AF.request(giphyAPI.url, method: .get, parameters: giphyAPI.parameters, headers: giphyAPI.headers).validate()
//                .responseDecodable(of: GIFSearchResponseDTO.self) { response in
//                    switch response.result {
//                    case .success(let data):
//                        continuation.resume(returning: data.toEntity())
//                    case .failure(_):
//                        if let statusCode = response.response?.statusCode {
//                            continuation.resume(throwing: SearchError(rawValue: statusCode) ?? .badRequest)
//                        } else {
//                            continuation.resume(throwing: SearchError(rawValue: 500) ?? .noNetwork)
//                        }
//                    }
//                }
        })
    }
}
