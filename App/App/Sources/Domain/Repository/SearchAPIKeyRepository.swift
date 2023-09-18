//
//  SearchAPIKeyRepository.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/26.
//

import Foundation

public enum SearchAPIKeyRepositoryError: Error {
    case notFound
    case badNetwork
}

public protocol SearchAPIKeyRepository {
    func get(for user: User) async throws -> SearchAPI.Key

    func clear()
}
