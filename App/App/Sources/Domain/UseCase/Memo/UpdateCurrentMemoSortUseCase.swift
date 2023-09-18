//
//  UpdateCurrentMemoSortUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/07/18.
//

import Foundation

public protocol UpdateCurrentMemoSortUseCase {
    func invoke(memoSort: MemoSort)
}

public final class UpdateCurrentMemoSortUseCaseImpl: UpdateCurrentMemoSortUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    public init(userActionHistoryRepository: UserActionHistoryRepository) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    public func invoke(memoSort: MemoSort) {
        return userActionHistoryRepository.update(currentMemoSort: memoSort)
    }
}
