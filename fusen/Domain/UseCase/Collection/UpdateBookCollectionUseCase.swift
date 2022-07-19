//
//  UpdateBookCollectionUseCase.swift
//  UpdateBookCollectionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum UpdateBookCollectionUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol UpdateBookCollectionUseCase {
    func invoke(book: Book, collection: Collection) async throws
}

final class UpdateBookCollectionUseCaseImpl: UpdateBookCollectionUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func invoke(book: Book, collection: Collection) async throws {
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
