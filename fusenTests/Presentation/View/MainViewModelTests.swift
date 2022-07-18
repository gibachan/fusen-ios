//
//  MainViewModelTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/19.
//

import Combine
import XCTest

@testable import fusen

class MainViewModelTests: XCTestCase {
    func testFirstAppLaunch() async {
        let accountService = MockAccountService(isLoggedIn: false)
        let getAppConfigUseCase = MockGetAppConfigUseCase(
            AppConfig(
                isMaintaining: false,
                isVisionAPIUse: false
            )
        )
        let viewModel = MainViewModel(
            accountService: accountService,
            getAppConfigUseCase: getAppConfigUseCase
        )
        var showTutorials: [Bool] = []
        var isMaintainings: [Bool] = []
        var cancellables = Set<AnyCancellable>()
        viewModel.$showTutorial
            .sink(receiveValue: { showTutorial in
                showTutorials.append(showTutorial)
            })
            .store(in: &cancellables)
        viewModel.$isMaintaining
            .sink(receiveValue: { isMaintaining in
                isMaintainings.append(isMaintaining)
            })
            .store(in: &cancellables)
        
        await viewModel.onAppear()
        cancellables.removeAll()

        XCTAssertEqual(showTutorials.count, 2)
        XCTAssertFalse(showTutorials[0])
        XCTAssertTrue(showTutorials[1])
        XCTAssertEqual(isMaintainings.count, 2)
        XCTAssertFalse(isMaintainings[0])
        XCTAssertFalse(isMaintainings[1])
    }
    
    func testAppLaunchWithUserLoggedIn() async {
        let accountService = MockAccountService(isLoggedIn: true)
        let getAppConfigUseCase = MockGetAppConfigUseCase(
            AppConfig(
                isMaintaining: false,
                isVisionAPIUse: false
            )
        )
        let viewModel = MainViewModel(
            accountService: accountService,
            getAppConfigUseCase: getAppConfigUseCase
        )
        var showTutorials: [Bool] = []
        var isMaintainings: [Bool] = []
        var cancellables = Set<AnyCancellable>()
        viewModel.$showTutorial
            .sink(receiveValue: { showTutorial in
                showTutorials.append(showTutorial)
            })
            .store(in: &cancellables)
        viewModel.$isMaintaining
            .sink(receiveValue: { isMaintaining in
                isMaintainings.append(isMaintaining)
            })
            .store(in: &cancellables)
        
        await viewModel.onAppear()
        cancellables.removeAll()

        XCTAssertEqual(showTutorials.count, 2)
        XCTAssertFalse(showTutorials[0])
        XCTAssertFalse(showTutorials[1])
        XCTAssertEqual(isMaintainings.count, 2)
        XCTAssertFalse(isMaintainings[0])
        XCTAssertFalse(isMaintainings[1])
    }
    
    func testMaintenanceMode() async {
        let accountService = MockAccountService(isLoggedIn: false)
        let getAppConfigUseCase = MockGetAppConfigUseCase(
            AppConfig(
                isMaintaining: true,
                isVisionAPIUse: false
            )
        )
        let viewModel = MainViewModel(
            accountService: accountService,
            getAppConfigUseCase: getAppConfigUseCase
        )
        var showTutorials: [Bool] = []
        var isMaintainings: [Bool] = []
        var cancellables = Set<AnyCancellable>()
        viewModel.$showTutorial
            .sink(receiveValue: { showTutorial in
                showTutorials.append(showTutorial)
            })
            .store(in: &cancellables)
        viewModel.$isMaintaining
            .sink(receiveValue: { isMaintaining in
                isMaintainings.append(isMaintaining)
            })
            .store(in: &cancellables)
        
        await viewModel.onAppear()
        cancellables.removeAll()

        XCTAssertEqual(showTutorials.count, 1)
        XCTAssertFalse(showTutorials[0])
        XCTAssertEqual(isMaintainings.count, 2)
        XCTAssertFalse(isMaintainings[0])
        XCTAssertTrue(isMaintainings[1])
    }
    
    func testLogoutWhenAppIsLaunchedAtFirstTime() async {
        let accountService = MockAccountService(isLoggedIn: true)
        let getAppConfigUseCase = MockGetAppConfigUseCase(
            AppConfig(
                isMaintaining: false,
                isVisionAPIUse: false
            )
        )
        let getUserActionHistoryUseCase = MockGetUserActionHistoryUseCase(
            UserActionHistory(
                launchedAppBefore: false,
                didConfirmReadingBookDescription: false,
                readBookPages: [:],
                reviewedVersion: nil,
                currentMemoSort: nil
            )
        )
        let launchAppUseCase = MockLaunchAppUseCase()
        var cancellables = Set<AnyCancellable>()
        let viewModel = MainViewModel(
            accountService: accountService,
            getAppConfigUseCase: getAppConfigUseCase,
            getUserActionHistoryUseCase: getUserActionHistoryUseCase,
            launchAppUseCase: launchAppUseCase
        )
        
        await viewModel.onAppear()
        cancellables.removeAll()
        
        XCTAssertTrue(launchAppUseCase.invoked)
        XCTAssertFalse(accountService.isLoggedIn)
    }
    
    func testDoNotLogoutWhenAppIsLaunchedAtFirstTime() async {
        let accountService = MockAccountService(isLoggedIn: true)
        let getAppConfigUseCase = MockGetAppConfigUseCase(
            AppConfig(
                isMaintaining: false,
                isVisionAPIUse: false
            )
        )
        let getUserActionHistoryUseCase = MockGetUserActionHistoryUseCase(
            UserActionHistory(
                launchedAppBefore: true,
                didConfirmReadingBookDescription: false,
                readBookPages: [:],
                reviewedVersion: nil,
                currentMemoSort: nil
            )
        )
        let launchAppUseCase = MockLaunchAppUseCase()
        var cancellables = Set<AnyCancellable>()
        let viewModel = MainViewModel(
            accountService: accountService,
            getAppConfigUseCase: getAppConfigUseCase,
            getUserActionHistoryUseCase: getUserActionHistoryUseCase,
            launchAppUseCase: launchAppUseCase
        )
        
        await viewModel.onAppear()
        cancellables.removeAll()
        
        XCTAssertTrue(launchAppUseCase.invoked)
        XCTAssertTrue(accountService.isLoggedIn)
    }
}

private final class MockGetUserActionHistoryUseCase: GetUserActionHistoryUseCase {
    private let history: UserActionHistory
    
    init(_ history: UserActionHistory) {
        self.history = history
    }
    
    func invoke() -> UserActionHistory {
        history
    }
}

private final class MockLaunchAppUseCase: LaunchAppUseCase {
    var invoked = false
    func invoke() {
        invoked = true
    }
}
