//
//  UpdateCurrentBookSortUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/07/19.
//

import Foundation

public protocol UpdateCurrentBookSortUseCase {
    func invoke(bookSort: BookSort)
}

public final class UpdateCurrentBookSortUseCaseImpl: UpdateCurrentBookSortUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    public init(userActionHistoryRepository: UserActionHistoryRepository) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    public func invoke(bookSort: BookSort) {
        return userActionHistoryRepository.update(currentBookSort: bookSort)
    }
}
