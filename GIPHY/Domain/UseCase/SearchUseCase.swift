//
//  SearchUseCase.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation

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
    ) async throws -> GIFs {
        do {
            return try await repository.requestGIFs(
                style: style,
                query: query,
                start: start,
                display: display
            )
        } catch {
            throw error
        }
    }
}
