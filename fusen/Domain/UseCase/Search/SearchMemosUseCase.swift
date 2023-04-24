//
//  SearchMemosUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/22.
//

import AlgoliaSearchClient
import Foundation

enum SearchMemosUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol SearchMemosUseCase {
    func invoke(searchText: String) async throws -> [Memo]
}

final class SearchMemosUseCaseImpl: SearchMemosUseCase {
    private let accountService: AccountServiceProtocol
    private let searchRepository: SearchRepository

    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        searchRepository: SearchRepository = MockSearchRepository()
    ) {
        self.accountService = accountService
        self.searchRepository = searchRepository
    }

    func invoke(searchText: String) async throws -> [Memo] {
        guard let user = accountService.currentUser else {
            throw SearchMemosUseCaseError.notAuthenticated
        }

        do {
            // TODO: Move to searchRepository
            let client = SearchClient(appID: "YourApplicationID", apiKey: "YourAdminAPIKey")
            let index = client.index(withName: "your_index_name")
            let results = try index.search(query: "test_record")
            print(results.hits[0])

            return try await searchRepository.memos(for: searchText)
        } catch {
            throw AddBookByManualUseCaseError.badNetwork
        }
    }
}
