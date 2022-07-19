//
//  ReviewAppUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/01/04.
//

import Foundation

protocol ReviewAppUseCase {
    func invoke(version: String)
}

final class ReviewAppUseCaseImpl: ReviewAppUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke(version: String) {
        userActionHistoryRepository.update(reviewedVersion: version)
    }
}
