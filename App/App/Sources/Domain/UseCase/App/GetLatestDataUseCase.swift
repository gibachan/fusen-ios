//
//  GetLatestDataUseCase.swift
//  GetLatestDataUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum GetLatestDataUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol GetLatestDataUseCase {
    func invoke(booksCount: Int, memosCount: Int) async throws -> LatestData
}

public final class GetLatestDataUseCaseImpl: GetLatestDataUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    private let memoRepository: MemoRepository

    public init(
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository,
        memoRpository: MemoRepository
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
        self.memoRepository = memoRpository
    }

    public func invoke(booksCount: Int, memosCount: Int) async throws -> LatestData {
        guard let user = accountService.currentUser else {
            throw GetLatestDataUseCaseError.notAuthenticated
        }

        async let books = bookRepository.getLatestBooks(count: booksCount, for: user)
        async let memos = memoRepository.getLatestMemos(count: memosCount, for: user)

        do {
            return try await LatestData(
                books: books,
                memos: memos
            )
        } catch {
            throw GetLatestDataUseCaseError.badNetwork
        }
    }
}
