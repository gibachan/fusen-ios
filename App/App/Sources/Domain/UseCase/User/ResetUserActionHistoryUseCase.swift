//
//  ResetUserActionHistoryUseCase.swift
//  ResetUserActionHistoryUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

public protocol ResetUserActionHistoryUseCase {
    func invoke()
}

public final class ResetUserActionHistoryUseCaseImpl: ResetUserActionHistoryUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    public init(userActionHistoryRepository: UserActionHistoryRepository) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    public func invoke() {
        userActionHistoryRepository.clearAll()
    }
}
