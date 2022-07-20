//
//  UpdateFavoriteBookUseCase.swift
//  UpdateFavoriteBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum UpdateFavoriteBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol UpdateFavoriteBookUseCase {
    func invoke(book: Book, isFavorite: Bool) async throws
}

final class UpdateFavoriteBookUseCaseImpl: UpdateFavoriteBookUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func invoke(book: Book, isFavorite: Bool) async throws {
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
