//
//  LaunchAppUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/01/05.
//

import Foundation

protocol LaunchAppUseCase {
    func invoke() async
}

final class LaunchAppUseCaseImpl: LaunchAppUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(
        userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()
    ) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke() async {
        await userActionHistoryRepository.update(launchedAppBefore: true)
    }
}
