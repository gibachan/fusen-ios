//
//  GetReadingBookUseCase.swift
//  GetReadingBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum GetReadingBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol GetReadingBookUseCase {
    func invoke() async throws -> Book?
}

final class GetReadingBookUseCaseImpl: GetReadingBookUseCase {
    private let accountService: AccountServiceProtocol
    private let userRepository: UserRepository
    private let bookRepository: BookRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        userRepository: UserRepository = UserRepositoryImpl(),
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.userRepository = userRepository
        self.bookRepository = bookRepository
    }
    
    func invoke() async throws -> Book? {
        guard let user = accountService.currentUser else {
            throw GetReadingBookUseCaseError.notAuthenticated
        }
        
        do {
            let userInfo = try await userRepository.getInfo(for: user)
            if let bookId = userInfo.readingBookId {
                return try await bookRepository.getBook(by: bookId, for: user)
            } else {
                return nil
            }
        } catch {
            throw GetReadingBookUseCaseError.badNetwork
        }
    }
}
