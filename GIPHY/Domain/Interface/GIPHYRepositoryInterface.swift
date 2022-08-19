//
//  GIPHYRepositoryInterface.swift
//  GIPHY
//
//  Created by Sang hun Lee on 2022/08/19.
//

import Foundation

protocol GIPHYRepositoryInterface {
    func requestGIFs(
        style: CategoryStatus,
        query: String,
        start: Int,
        display: Int
    ) async throws -> GIFs
}
