//
//  GetBooksByCollectionUseCase.swift
//  GetBooksByCollectionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum GetBooksByCollectionUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol GetBooksByCollectionUseCase {
    func invoke(forceRefresh: Bool) async throws -> Pager<Book>
    func invokeNext() async throws -> Pager<Book>
}

public final class GetBooksByCollectionUseCaseImpl: GetBooksByCollectionUseCase {
    private let collection: Collection
    private let sortedBy: BookSort
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    public init(
        collection: Collection,
        sortedBy: BookSort,
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository
    ) {
        self.collection = collection
        self.sortedBy = sortedBy
        self.accountService = accountService
        self.bookRepository = bookRepository
    }

    public func invoke(forceRefresh: Bool) async throws -> Pager<Book> {
        guard let user = accountService.currentUser else {
            throw GetBooksByCollectionUseCaseError.notAuthenticated
        }

        do {
            let pager = try await bookRepository.getBooks(by: collection, sortedBy: sortedBy, for: user, forceRefresh: forceRefresh)
            return pager
        } catch {
            throw GetBooksByCollectionUseCaseError.badNetwork
        }
    }

    public func invokeNext() async throws -> Pager<Book> {
        guard let user = accountService.currentUser else {
            throw GetFavoriteBooksUseCaseError.notAuthenticated
        }

        do {
            let pager = try await bookRepository.getBooksNext(by: collection, for: user)
            return pager
        } catch {
            throw GetBooksByCollectionUseCaseError.badNetwork
        }
    }
}
