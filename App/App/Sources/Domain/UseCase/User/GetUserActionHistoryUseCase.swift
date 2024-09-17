//
//  GetUserActionHistoryUseCase.swift
//  GetUserActionHistoryUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

public protocol GetUserActionHistoryUseCase {
    func invoke() -> UserActionHistory
}

public final class GetUserActionHistoryUseCaseImpl: GetUserActionHistoryUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository

    public init(userActionHistoryRepository: UserActionHistoryRepository) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }

    public func invoke() -> UserActionHistory {
        return userActionHistoryRepository.get()
    }
}
