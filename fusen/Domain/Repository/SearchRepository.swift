//
//  SearchRepository.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/22.
//

import Foundation

enum SearchRepositoryError: Error {
    case forbidden
    case badNetwork
}

protocol SearchRepository {
    func memos(withAPIKey key: SearchAPIKey, for text: String) async throws -> [Memo]
}
