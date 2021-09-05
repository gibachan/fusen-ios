//
//  UpdateBookUseCase.swift
//  UpdateBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum UpdateBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol UpdateBookUseCase {
    func invoke(book: Book, title: String, author: String, description: String) async throws
}

final class UpdateBookUseCaseImpl: UpdateBookUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func invoke(book: Book, title: String, author: String, description: String) async throws {
        guard let user = accountService.currentUser else {
            throw UpdateFavoriteBookUseCaseError.notAuthenticated
        }
        
        do {
            try await bookRepository.update(book: book, title: title, author: author, description: description, for: user)
        } catch {
            throw UpdateFavoriteBookUseCaseError.badNetwork
        }
    }
}
