//
//  LaunchAppUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/01/05.
//

import Foundation

public protocol LaunchAppUseCase {
    func invoke()
}

public final class LaunchAppUseCaseImpl: LaunchAppUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository

    public init(
        userActionHistoryRepository: UserActionHistoryRepository
    ) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }

    public func invoke() {
        userActionHistoryRepository.update(launchedAppBefore: true)
    }
}
