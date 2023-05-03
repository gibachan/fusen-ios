//
//  SearchAPIKeyRepository.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/26.
//

import Foundation

enum SearchAPIKeyRepositoryError: Error {
    case notFound
    case badNetwork
}

protocol SearchAPIKeyRepository {
    func get(for user: User) async throws -> SearchAPIKey
}
