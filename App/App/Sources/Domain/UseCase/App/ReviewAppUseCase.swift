//
//  ReviewAppUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/01/04.
//

import Foundation

public protocol ReviewAppUseCase {
    func invoke(version: String)
}

public final class ReviewAppUseCaseImpl: ReviewAppUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository

    public init(userActionHistoryRepository: UserActionHistoryRepository) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }

    public func invoke(version: String) {
        userActionHistoryRepository.update(reviewedVersion: version)
    }
}
