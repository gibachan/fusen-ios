//
//  SearchMemosUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/22.
//

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
    private let searchAPIKeyRepository: SearchAPIKeyRepository
    private let searchRepository: SearchRepository

    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        searchAPIKeyRepository: SearchAPIKeyRepository = SearchAPIKeyRepositoryImpl(),
        searchRepository: SearchRepository = SearchRepositoryImpl()
    ) {
        self.accountService = accountService
        self.searchAPIKeyRepository = searchAPIKeyRepository
        self.searchRepository = searchRepository
    }

    func invoke(searchText: String) async throws -> [Memo] {
        guard let user = accountService.currentUser else {
            throw SearchMemosUseCaseError.notAuthenticated
        }

        let searchAPIKey: SearchAPIKey
        do {
            searchAPIKey = try await searchAPIKeyRepository.get(for: user)
        } catch {
            throw SearchMemosUseCaseError.badNetwork
        }

        do {
            return try await searchRepository.memos(withAPIKey: searchAPIKey, for: searchText)
        } catch {
            throw SearchMemosUseCaseError.badNetwork
        }
    }
}
