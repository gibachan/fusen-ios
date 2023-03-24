//
//  GetBooksCountUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/03/24.
//

import Foundation

enum GetBooksCountUseCaseError: Error {
    case notAuthenticated
    case network
}

protocol GetBooksCountUseCase {
    func invoke() async throws -> Int
}

final class GetBooksCountUseCaseImpl: GetBooksCountUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }

    func invoke() async throws -> Int {
        guard let user = accountService.currentUser else {
            throw GetBooksCountUseCaseError.notAuthenticated
        }

        do {
            return try await bookRepository.getAllBooksCount(for: user)
        } catch {
            throw GetBooksCountUseCaseError.network
        }
    }
}
