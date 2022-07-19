//
//  GetCurrentMemoSortUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/07/18.
//

import Foundation

protocol GetCurrentMemoSortUseCase {
    func invoke() -> MemoSort
}

final class GetCurrentMemoSortUseCaseImpl: GetCurrentMemoSortUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke() -> MemoSort {
        let userAcitonHistory = userActionHistoryRepository.get()
        return userAcitonHistory.currentMemoSort ?? .default
    }
}
