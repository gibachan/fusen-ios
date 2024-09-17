//
//  GetBookByIdUseCase.swift
//  GetBookByIdUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum GetBookByIdUseCaseError: Error {
    case notAuthenticated
    case notFound
}

public protocol GetBookByIdUseCase {
    func invoke(id: ID<Book>) async throws -> Book
}

public final class GetBookByIdUseCaseImpl: GetBookByIdUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    public init(
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }

    public func invoke(id: ID<Book>) async throws -> Book {
        guard let user = accountService.currentUser else {
            throw GetBookByIdUseCaseError.notAuthenticated
        }

        do {
            return try await bookRepository.getBook(by: id, for: user)
        } catch {
            throw GetBookByIdUseCaseError.notFound
        }
    }
}
