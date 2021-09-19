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
        await viewModel.$showTutorial
            .sink(receiveValue: { showTutorial in
                showTutorials.append(showTutorial)
            })
            .store(in: &cancellables)
        await viewModel.$isMaintaining
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
        await viewModel.$showTutorial
            .sink(receiveValue: { showTutorial in
                showTutorials.append(showTutorial)
            })
            .store(in: &cancellables)
        await viewModel.$isMaintaining
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
        await viewModel.$showTutorial
            .sink(receiveValue: { showTutorial in
                showTutorials.append(showTutorial)
            })
            .store(in: &cancellables)
        await viewModel.$isMaintaining
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
}
