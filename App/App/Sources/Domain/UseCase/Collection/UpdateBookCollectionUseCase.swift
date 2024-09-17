//
//  UpdateBookCollectionUseCase.swift
//  UpdateBookCollectionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum UpdateBookCollectionUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol UpdateBookCollectionUseCase {
    func invoke(book: Book, collection: Collection) async throws
}

public final class UpdateBookCollectionUseCaseImpl: UpdateBookCollectionUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    public init(
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }

    public func invoke(book: Book, collection: Collection) async throws {
        guard let user = accountService.currentUser else {
            throw UpdateBookCollectionUseCaseError.notAuthenticated
        }

        do {
            try await bookRepository.update(book: book, collection: collection, for: user)
        } catch {
            throw UpdateBookCollectionUseCaseError.badNetwork
        }
    }
}
