//
//  GetCurrentMemoSortUseCaseTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/07/18.
//

@testable import fusen
import XCTest

class GetCurrentMemoSortUseCaseTests: XCTestCase {
    func testReturnsDefaultSortWhenItIsNotSavedYet() {
        let actionHistory = UserActionHistory(launchedAppBefore: false,
                                              didConfirmReadingBookDescription: false,
                                              readBookPages: [:],
                                              reviewedVersion: nil,
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
                                              currentMemoSort: .page)
        let repository = MockUserActionHistoryRepository(userActionHistory: actionHistory)
        let useCase = GetCurrentMemoSortUseCaseImpl(userActionHistoryRepository: repository)
        
        XCTAssertEqual(useCase.invoke(), .page)
    }
}
