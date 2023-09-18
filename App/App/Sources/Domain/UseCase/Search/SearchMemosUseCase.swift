//
//  SearchMemosUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/22.
//

import Foundation

public enum SearchMemosUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol SearchMemosUseCase {
    func invoke(searchText: String, searchType: SearchMemoType) async throws -> [Memo]
}

public final class SearchMemosUseCaseImpl: SearchMemosUseCase {
    private let accountService: AccountServiceProtocol
    private let searchAPIKeyRepository: SearchAPIKeyRepository
    private let searchRepository: SearchRepository
    private let memoRepository: MemoRepository

    public init(
        accountService: AccountServiceProtocol,
        searchAPIKeyRepository: SearchAPIKeyRepository,
        searchRepository: SearchRepository,
        memoRepository: MemoRepository
    ) {
        self.accountService = accountService
        self.searchAPIKeyRepository = searchAPIKeyRepository
        self.searchRepository = searchRepository
        self.memoRepository = memoRepository
    }

    public func invoke(searchText: String, searchType: SearchMemoType) async throws -> [Memo] {
        guard let user = accountService.currentUser else {
            throw SearchMemosUseCaseError.notAuthenticated
        }

        let searchAPIKey: SearchAPI.Key
        do {
            searchAPIKey = try await searchAPIKeyRepository.get(for: user)
        } catch {
            throw SearchMemosUseCaseError.badNetwork
        }

        do {
            let searchedMemoIDs = try await searchRepository.memos(
                withAPIKey: searchAPIKey,
                for: searchText,
                by: searchType
            )

            return try await withThrowingTaskGroup(of: Memo.self) { group in
                for memoID in searchedMemoIDs {
                    group.addTask {
                        try await self.memoRepository.getMemo(by: memoID, for: user)
                    }
                }

                return try await group.reduce(into: [Memo]()) { results, memo in
                    results.append(memo)
                }
            }
        } catch {
            // TODO: Remove key if it was invalid key
            // searchAPIKeyRepository.clear()

            throw SearchMemosUseCaseError.badNetwork
        }
    }
}
