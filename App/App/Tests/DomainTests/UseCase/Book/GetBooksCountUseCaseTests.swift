//
//  GetBooksCountUseCaseTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2023/03/24.
//

import Domain
import XCTest

class GetBooksCountUseCaseTests: XCTestCase {
    func testGetBooksCount() async throws {
        let accountService = MockAccountService(isLoggedIn: true)
        let bookRepository = MockBookRepository(
            getAllBooksCountResult: 100
        )
        let useCase = GetBooksCountUseCaseImpl(accountService: accountService,
                                               bookRepository: bookRepository)

        let count = try await useCase.invoke()

        XCTAssertEqual(count, 100)
    }

    func testGetBooksCountThrowsErrorWhenAccountIsNotLoggedIn() async throws {
        let accountService = MockAccountService(isLoggedIn: false)
        let bookRepository = MockBookRepository(
            getAllBooksCountResult: 100
        )
        let useCase = GetBooksCountUseCaseImpl(accountService: accountService,
                                               bookRepository: bookRepository)

        await XCTAssertThrowsError(try await useCase.invoke())
    }
}
