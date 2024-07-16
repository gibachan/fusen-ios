//
//  GetCurrentBookSortUseCaseTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/07/19.
//

import Domain
import XCTest

class GetCurrentBookSortUseCaseTests: XCTestCase {
    func testReturnsDefaultSortWhenItIsNotSavedYet() {
        let actionHistory = UserActionHistory(launchedAppBefore: false,
                                              didConfirmReadingBookDescription: false,
                                              readBookPages: [:],
                                              reviewedVersion: nil,
                                              currentBookSort: nil,
                                              currentMemoSort: nil)
        let repository = MockUserActionHistoryRepository(userActionHistory: actionHistory)
        let useCase = GetCurrentBookSortUseCaseImpl(userActionHistoryRepository: repository)
        
        XCTAssertEqual(useCase.invoke(), .default)
    }
    
    func testReturnsSavedSort() {
        let actionHistory = UserActionHistory(launchedAppBefore: false,
                                              didConfirmReadingBookDescription: false,
                                              readBookPages: [:],
                                              reviewedVersion: nil,
                                              currentBookSort: .title,
                                              currentMemoSort: nil)
        let repository = MockUserActionHistoryRepository(userActionHistory: actionHistory)
        let useCase = GetCurrentBookSortUseCaseImpl(userActionHistoryRepository: repository)
        
        XCTAssertEqual(useCase.invoke(), .title)
    }
}
