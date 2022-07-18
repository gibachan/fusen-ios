//
//  UpdateCurrentMemoSortUseCaseTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/07/18.
//

@testable import fusen
import XCTest

class UpdateCurrentMemoSortUseCaseTests: XCTestCase {
    func testItUpdatesCurrentMemoSort() {
        let actionHistory = UserActionHistory(launchedAppBefore: false,
                                              didConfirmReadingBookDescription: false,
                                              readBookPages: [:],
                                              reviewedVersion: nil,
                                              currentMemoSort: nil)
        let repository = MockUserActionHistoryRepository(userActionHistory: actionHistory)
        let useCase = UpdateCurrentMemoSortUseCaseImpl(userActionHistoryRepository: repository)
        
        useCase.invoke(memoSort: .page)
        
        let result = repository.get()
        XCTAssertEqual(result.currentMemoSort, .page)
    }
}
