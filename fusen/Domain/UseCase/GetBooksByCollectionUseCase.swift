//
//  GetBooksByCollectionUseCase.swift
//  GetBooksByCollectionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum GetBooksByCollectionUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol GetBooksByCollectionUseCase {
    func invoke(forceRefresh: Bool) async throws -> Pager<Book>
    func invokeNext() async throws -> Pager<Book>
}

final class GetBooksByCollectionUseCaseImpl: GetBooksByCollectionUseCase {
    private let collection: Collection
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    init(
        collection: Collection,
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.collection = collection
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func invoke(forceRefresh: Bool) async throws -> Pager<Book> {
        guard let user = accountService.currentUser else {
            throw GetBooksByCollectionUseCaseError.notAuthenticated
        }
       
        do {
            let pager = try await bookRepository.getBooks(by: collection, for: user, forceRefresh: forceRefresh)
            return pager
        } catch {
            throw GetBooksByCollectionUseCaseError.badNetwork
        }
    }
    
    func invokeNext() async throws -> Pager<Book> {
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
