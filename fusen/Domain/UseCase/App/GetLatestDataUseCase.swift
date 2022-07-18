//
//  GetLatestDataUseCase.swift
//  GetLatestDataUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum GetLatestDataUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol GetLatestDataUseCase {
    func invoke(booksCount: Int, memosCount: Int) async throws -> LatestData
}

final class GetLatestDataUseCaseImpl: GetLatestDataUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    private let memoRepository: MemoRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl(),
        memoRpository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
        self.memoRepository = memoRpository
    }
    
    func invoke(booksCount: Int, memosCount: Int) async throws -> LatestData {
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
