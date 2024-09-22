//
//  AddBookByPublicationUseCase.swift
//  AddBookByPublicationUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum AddBookByPublicationUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol AddBookByPublicationUseCase {
    func invoke(publication: Publication, collection: Collection?) async throws -> ID<Book>
}

public final class AddBookByPublicationUseCaseImpl: AddBookByPublicationUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    public init(
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }

    public func invoke(publication: Publication, collection: Collection?) async throws -> ID<Book> {
        guard let user = accountService.currentUser else {
            throw AddBookByPublicationUseCaseError.notAuthenticated
        }

        do {
            return try await bookRepository.addBook(of: publication, in: collection, image: nil, for: user)
        } catch {
            throw AddBookByPublicationUseCaseError.badNetwork
        }
    }
}
