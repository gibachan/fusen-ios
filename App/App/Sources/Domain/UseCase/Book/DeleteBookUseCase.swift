//
//  DeleteBookUseCase.swift
//  DeleteBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum DeleteBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol DeleteBookUseCase {
    func invoke(book: Book) async throws
}

public final class DeleteBookUseCaseImpl: DeleteBookUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    public init(
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }

    public func invoke(book: Book) async throws {
        guard let user = accountService.currentUser else {
            throw UpdateFavoriteBookUseCaseError.notAuthenticated
        }

        do {
            try await bookRepository.delete(book: book, for: user)
        } catch {
            throw UpdateFavoriteBookUseCaseError.badNetwork
        }
    }
}
