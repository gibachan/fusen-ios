//
//  UpdateFavoriteBookUseCase.swift
//  UpdateFavoriteBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum UpdateFavoriteBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol UpdateFavoriteBookUseCase {
    func invoke(book: Book, isFavorite: Bool) async throws
}

public final class UpdateFavoriteBookUseCaseImpl: UpdateFavoriteBookUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    public init(
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }

    public func invoke(book: Book, isFavorite: Bool) async throws {
        guard let user = accountService.currentUser else {
            throw UpdateFavoriteBookUseCaseError.notAuthenticated
        }

        do {
            try await bookRepository.update(book: book, isFavorite: isFavorite, for: user)
        } catch {
            throw UpdateFavoriteBookUseCaseError.badNetwork
        }
    }
}
