//
//  UpdateCurrentMemoSortUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/07/18.
//

import Foundation

protocol UpdateCurrentMemoSortUseCase {
    func invoke(memoSort: MemoSort)
}

final class UpdateCurrentMemoSortUseCaseImpl: UpdateCurrentMemoSortUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke(memoSort: MemoSort) {
        return userActionHistoryRepository.update(currentMemoSort: memoSort)
    }
}
