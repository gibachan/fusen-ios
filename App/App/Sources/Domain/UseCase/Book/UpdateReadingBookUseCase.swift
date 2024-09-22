//
//  UpdateReadingBookUseCase.swift
//  UpdateReadingBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation
import WidgetKit

public enum UpdateReadingBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol UpdateReadingBookUseCase {
    func invoke(readingBook: Book?) async throws
}

public final class UpdateReadingBookUseCaseImpl: UpdateReadingBookUseCase {
    private let accountService: AccountServiceProtocol
    private let userRepository: UserRepository

    public init(
        accountService: AccountServiceProtocol,
        userRepository: UserRepository
    ) {
        self.accountService = accountService
        self.userRepository = userRepository
    }

    public func invoke(readingBook: Book?) async throws {
        guard let user = accountService.currentUser else {
            throw UpdateReadingBookUseCaseError.notAuthenticated
        }

        do {
            try await userRepository.update(readingBook: readingBook, for: user)
            // FIXME: Call widget update via Protocol
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            throw UpdateReadingBookUseCaseError.badNetwork
        }
    }
}
