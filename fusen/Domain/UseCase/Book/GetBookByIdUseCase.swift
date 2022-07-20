//
//  GetBookByIdUseCase.swift
//  GetBookByIdUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum GetBookByIdUseCaseError: Error {
    case notAuthenticated
    case notFound
}

protocol GetBookByIdUseCase {
    func invoke(id: ID<Book>) async throws -> Book
}

final class GetBookByIdUseCaseImpl: GetBookByIdUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func invoke(id: ID<Book>) async throws -> Book {
        guard let user = accountService.currentUser else {
            throw GetBookByIdUseCaseError.notAuthenticated
        }
        
        do {
            return try await bookRepository.getBook(by: id, for: user)
        } catch {
            throw GetBookByIdUseCaseError.notFound
        }
    }
}
