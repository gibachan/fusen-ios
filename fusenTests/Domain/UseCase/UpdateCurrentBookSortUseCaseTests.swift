//
//  UpdateCurrentBookSortUseCaseTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/07/19.
//

@testable import fusen
import XCTest

class UpdateCurrentBookSortUseCaseTests: XCTestCase {
    func testItUpdatesCurrentMemoSort() {
        let actionHistory = UserActionHistory(launchedAppBefore: false,
                                              didConfirmReadingBookDescription: false,
                                              readBookPages: [:],
                                              reviewedVersion: nil,
                                              currentBookSort: nil,
                                              currentMemoSort: nil)
        let repository = MockUserActionHistoryRepository(userActionHistory: actionHistory)
        let useCase = UpdateCurrentBookSortUseCaseImpl(userActionHistoryRepository: repository)
        
        useCase.invoke(bookSort: .title)
        
        let result = repository.get()
        XCTAssertEqual(result.currentBookSort, .title)
    }
}
