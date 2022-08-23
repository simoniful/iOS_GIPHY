//
//  SearchUseCase.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchUseCase {

    let repository: GIPHYRepositoryInterface

    init(repository: GIPHYRepositoryInterface) {
        self.repository = repository
    }

    func requestGIFs(
        style: CategoryStatus,
        query: String,
        start: Int,
        display: Int
    ) -> Single<NetworkResult> {
        return repository.requestGIFs(
            style: style,
            query: query,
            start: start,
            display: display
        )
    }
}
