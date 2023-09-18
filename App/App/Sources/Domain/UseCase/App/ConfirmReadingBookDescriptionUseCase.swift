//
//  ConfirmReadingBookDescriptionUseCase.swift
//  ConfirmReadingBookDescriptionUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

public protocol ConfirmReadingBookDescriptionUseCase {
    func invoke()
}

public final class ConfirmReadingBookDescriptionUseCaseImpl: ConfirmReadingBookDescriptionUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    public init(userActionHistoryRepository: UserActionHistoryRepository
    ) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    public func invoke() {
        userActionHistoryRepository.update(didConfirmReadingBookDescription: true)
    }
}
