//
//  SearchRepository.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/22.
//

import Foundation

enum SearchRepositoryError: Error {
    case badNetwork
}

protocol SearchRepository {
    func memos(for text: String) async throws -> [Memo]
}

struct MockSearchRepository: SearchRepository {
    func memos(for text: String) async throws -> [Memo] {
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return [
                .sample
            ]
        } catch {
            print(error)
            throw SearchRepositoryError.badNetwork
        }
    }
}
