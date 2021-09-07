//
//  ResetUserActionHistoryUseCase.swift
//  ResetUserActionHistoryUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

protocol ResetUserActionHistoryUseCase {
    func invoke() async
}

final class ResetUserActionHistoryUseCaseImpl: ResetUserActionHistoryUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke() async {
        await userActionHistoryRepository.update(didConfirmReadingBookDescription: false)
    }
}
