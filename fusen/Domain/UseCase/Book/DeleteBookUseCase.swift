//
//  DeleteBookUseCase.swift
//  DeleteBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum DeleteBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol DeleteBookUseCase {
    func invoke(book: Book) async throws
}

final class DeleteBookUseCaseImpl: DeleteBookUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func invoke(book: Book) async throws {
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
