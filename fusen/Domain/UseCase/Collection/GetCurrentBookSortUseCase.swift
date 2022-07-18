//
//  GetCurrentBookSortUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/07/19.
//

import Foundation

protocol GetCurrentBookSortUseCase {
    func invoke() -> BookSort
}

final class GetCurrentBookSortUseCaseImpl: GetCurrentBookSortUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke() -> BookSort {
        let userAcitonHistory = userActionHistoryRepository.get()
        return userAcitonHistory.currentBookSort ?? .default
    }
}
