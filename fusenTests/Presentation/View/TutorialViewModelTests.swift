//
//  TutorialViewModelTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/18.
//

import XCTest

@testable import fusen

class TutorialViewModelTests: XCTestCase {
    func testSkip() async {
        let accountService = MockAccountService(isLoggedIn: false)
        let viewModel = TutorialViewModel(accountService: accountService)
        var states: [TutorialViewModel.State] = []
        let cancellable = viewModel.$state
            .sink(receiveValue: { state in
                states.append(state)
            })
        
        await viewModel.onSkip()
        
        // Wait for main loop proceeds
        let expectation = self.expectation(description: #file)
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        await self.waitForExpectations(timeout: 1, handler: nil)

        cancellable.cancel()

        XCTAssertEqual(states.count, 3)
        XCTAssertEqual(states[0], .initial)
        XCTAssertEqual(states[1], .loading)
        XCTAssertEqual(states[2], .succeeded)
        XCTAssertTrue(accountService.isLoggedInAnonymously)
        XCTAssertFalse(accountService.isLoggedInWithApple)
    }
}
