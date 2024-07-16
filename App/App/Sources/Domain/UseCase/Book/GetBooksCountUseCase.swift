//
//  GetBooksCountUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/03/24.
//

import Foundation

public enum GetBooksCountUseCaseError: Error {
    case notAuthenticated
    case network
}

public protocol GetBooksCountUseCase {
    func invoke() async throws -> Int
}

public final class GetBooksCountUseCaseImpl: GetBooksCountUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    public init(
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }

    public func invoke() async throws -> Int {
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
