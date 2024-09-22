//
//  MockUserActionHistoryRepository.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/07/18.
//

import Domain
import Foundation
@testable import fusen

final class MockUserActionHistoryRepository: UserActionHistoryRepository {
    private var userActionHistory: UserActionHistory

    init(userActionHistory: UserActionHistory) {
        self.userActionHistory = userActionHistory
    }

    func get() -> UserActionHistory { userActionHistory }

    func update(didConfirmReadingBookDescription: Bool) {}

    func update(readBook: Book, page: Int) {}

    func update(reviewedVersion: String) {}

    func update(launchedAppBefore: Bool) {}

    func update(currentBookSort: BookSort) {
        userActionHistory = .init(launchedAppBefore: userActionHistory.launchedAppBefore,
                                  didConfirmReadingBookDescription: userActionHistory.didConfirmReadingBookDescription,
                                  readBookPages: userActionHistory.readBookPages,
                                  reviewedVersion: userActionHistory.reviewedVersion,
                                  currentBookSort: currentBookSort,
                                  currentMemoSort: userActionHistory.currentMemoSort)
    }

    func update(currentMemoSort: MemoSort) {
        userActionHistory = .init(launchedAppBefore: userActionHistory.launchedAppBefore,
                                  didConfirmReadingBookDescription: userActionHistory.didConfirmReadingBookDescription,
                                  readBookPages: userActionHistory.readBookPages,
                                  reviewedVersion: userActionHistory.reviewedVersion,
                                  currentBookSort: userActionHistory.currentBookSort,
                                  currentMemoSort: currentMemoSort)
    }

    func clearAll() {}
}
