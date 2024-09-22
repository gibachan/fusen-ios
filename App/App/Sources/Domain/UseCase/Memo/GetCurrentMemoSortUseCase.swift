//
//  GetCurrentMemoSortUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/07/18.
//

import Foundation

public protocol GetCurrentMemoSortUseCase {
    func invoke() -> MemoSort
}

public final class GetCurrentMemoSortUseCaseImpl: GetCurrentMemoSortUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository

    public init(userActionHistoryRepository: UserActionHistoryRepository) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }

    public func invoke() -> MemoSort {
        let userAcitonHistory = userActionHistoryRepository.get()
        return userAcitonHistory.currentMemoSort ?? .default
    }
}
