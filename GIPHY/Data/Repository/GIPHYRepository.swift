//
//  GIPHYRepository.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import RxSwift
import Alamofire

final class GIPHYRepository: GIPHYRepositoryInterface {
    private let disposeBag = DisposeBag()

    func requestGIFs(
        style: CategoryStatus,
        query: String,
        start: Int,
        display: Int
    ) -> Single<NetworkResult>  {
        var giphyAPI: GIPHYAPI = .getGifData(query: query, start: start, display: display)

        switch style {
        case .gif:
            giphyAPI = .getGifData(query: query, start: start, display: display)
        case .sticker:
            giphyAPI = .getStickerData(query: query, start: start, display: display)
        case .text:
            giphyAPI = .getTextData(query: query, start: start, display: display)
        }

        return Single.create { single in
            let request = AF.request(
                giphyAPI.url,
                method: .get,
                parameters: giphyAPI.parameters,
                headers: giphyAPI.headers
            )
                .responseData { response in
                    switch response.result {
                    case let .success(jsonData):
                        do {
                            let returnObject = try JSONDecoder().decode(GIFSearchResponseDTO.self, from: jsonData)
                            single(.success(.success(returnObject.toEntity())))
                        } catch let error {
                            single(.failure(error))
                        }
                        
                    case .failure(_):
                        if let statusCode = response.response?.statusCode {
                            if let networkError = NetworkError(rawValue: statusCode){
                                single(.success(.error(networkError)))
                            }
                        }
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
