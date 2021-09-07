//
//  GetUserActionHistoryUseCase.swift
//  GetUserActionHistoryUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

protocol GetUserActionHistoryUseCase {
    func invoke() async -> UserActionHistory
}

final class GetUserActionHistoryUseCaseImpl: GetUserActionHistoryUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke() async -> UserActionHistory {
        return await userActionHistoryRepository.get()
    }
}
