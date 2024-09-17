//
//  GetReadingBookUseCase.swift
//  GetReadingBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum GetReadingBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol GetReadingBookUseCase {
    func invoke() async throws -> Book?
}

public final class GetReadingBookUseCaseImpl: GetReadingBookUseCase {
    private let accountService: AccountServiceProtocol
    private let userRepository: UserRepository
    private let bookRepository: BookRepository

    public init(
        accountService: AccountServiceProtocol,
        userRepository: UserRepository,
        bookRepository: BookRepository
    ) {
        self.accountService = accountService
        self.userRepository = userRepository
        self.bookRepository = bookRepository
    }

    public func invoke() async throws -> Book? {
        guard let user = accountService.currentUser else {
            throw GetReadingBookUseCaseError.notAuthenticated
        }

        do {
            let userInfo = try await userRepository.getInfo(for: user)
            // TODO: Cache reading book
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
