//
//  TutorialViewModelTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/18.
//

import Combine
import XCTest

@testable import fusen

class TutorialViewModelTests: XCTestCase {
    func testSkip() async {
        let accountService = MockAccountService(isLoggedIn: false)
        let viewModel = TutorialViewModel(accountService: accountService)
        var states: [TutorialViewModel.State] = []
        var cancellables = Set<AnyCancellable>()
        viewModel.$state
            .sink(receiveValue: { state in
                states.append(state)
            })
            .store(in: &cancellables)
        
        await viewModel.onSkip()
        cancellables.removeAll()

        XCTAssertEqual(states.count, 3)
        XCTAssertEqual(states[0], .initial)
        XCTAssertEqual(states[1], .loading)
        XCTAssertEqual(states[2], .succeeded)
        XCTAssertTrue(accountService.isLoggedInAnonymously)
        XCTAssertFalse(accountService.isLoggedInWithApple)
    }
}
