//
//  ConfirmReadingBookDescriptionUseCase.swift
//  ConfirmReadingBookDescriptionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

protocol ConfirmReadingBookDescriptionUseCase {
    func invoke()
}

final class ConfirmReadingBookDescriptionUseCaseImpl: ConfirmReadingBookDescriptionUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke() {
        userActionHistoryRepository.update(didConfirmReadingBookDescription: true)
    }
}
