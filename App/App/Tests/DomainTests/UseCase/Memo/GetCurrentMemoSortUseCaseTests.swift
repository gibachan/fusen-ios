//
//  GetCurrentMemoSortUseCaseTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/07/18.
//

import Domain
import XCTest

class GetCurrentMemoSortUseCaseTests: XCTestCase {
    func testReturnsDefaultSortWhenItIsNotSavedYet() {
        let actionHistory = UserActionHistory(launchedAppBefore: false,
                                              didConfirmReadingBookDescription: false,
                                              readBookPages: [:],
                                              reviewedVersion: nil,
                                              currentBookSort: nil,
                                              currentMemoSort: nil)
        let repository = MockUserActionHistoryRepository(userActionHistory: actionHistory)
        let useCase = GetCurrentMemoSortUseCaseImpl(userActionHistoryRepository: repository)
        
        XCTAssertEqual(useCase.invoke(), .default)
    }
    
    func testReturnsSavedSort() {
        let actionHistory = UserActionHistory(launchedAppBefore: false,
                                              didConfirmReadingBookDescription: false,
                                              readBookPages: [:],
                                              reviewedVersion: nil,
                                              currentBookSort: nil,
                                              currentMemoSort: .page)
        let repository = MockUserActionHistoryRepository(userActionHistory: actionHistory)
        let useCase = GetCurrentMemoSortUseCaseImpl(userActionHistoryRepository: repository)
        
        XCTAssertEqual(useCase.invoke(), .page)
    }
}
