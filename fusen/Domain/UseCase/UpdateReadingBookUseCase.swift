//
//  UpdateReadingBookUseCase.swift
//  UpdateReadingBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum UpdateReadingBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol UpdateReadingBookUseCase {
    func invoke(readingBook: Book?) async throws
}

final class UpdateReadingBookUseCaseImpl: UpdateReadingBookUseCase {
    private let accountService: AccountServiceProtocol
    private let userRepository: UserRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        userRepository: UserRepository = UserRepositoryImpl()
    ) {
        self.accountService = accountService
        self.userRepository = userRepository
    }
    
    func invoke(readingBook: Book?) async throws {
        guard let user = accountService.currentUser else {
            throw UpdateReadingBookUseCaseError.notAuthenticated
        }
        
        do {
            try await userRepository.update(readingBook: readingBook, for: user)
        } catch {
            throw UpdateReadingBookUseCaseError.badNetwork
        }
    }
}
