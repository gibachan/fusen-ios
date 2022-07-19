//
//  UpdateCurrentBookSortUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/07/19.
//

import Foundation

protocol UpdateCurrentBookSortUseCase {
    func invoke(bookSort: BookSort)
}

final class UpdateCurrentBookSortUseCaseImpl: UpdateCurrentBookSortUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke(bookSort: BookSort) {
        return userActionHistoryRepository.update(currentBookSort: bookSort)
    }
}
