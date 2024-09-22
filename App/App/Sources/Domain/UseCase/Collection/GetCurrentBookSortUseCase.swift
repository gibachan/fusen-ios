//
//  GetCurrentBookSortUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/07/19.
//

import Foundation

public protocol GetCurrentBookSortUseCase {
    func invoke() -> BookSort
}

public final class GetCurrentBookSortUseCaseImpl: GetCurrentBookSortUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository

    public init(userActionHistoryRepository: UserActionHistoryRepository) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }

    public func invoke() -> BookSort {
        let userAcitonHistory = userActionHistoryRepository.get()
        return userAcitonHistory.currentBookSort ?? .default
    }
}
