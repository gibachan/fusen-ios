//
//  UpdateMemoUseCaseTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/22.
//

import Domain
import XCTest

class UpdateMemoUseCaseTests: XCTestCase {
    func testThrowsNotAuthenticated() async {
        let accountService = MockAccountService(isLoggedIn: false)
        let memoRepository = MockMemoRepository()
        let useCase = UpdateMemoUseCaseImpl(accountService: accountService, memoRepository: memoRepository)

        await assertThrows(
            try await useCase.invoke(memo: Memo.sample, text: "text", quote: "quote", page: 1, imageURLs: []),
            throws: UpdateMemoUseCaseError.notAuthenticated
        )
    }

    func testBadNetowrkError() async {
        let accountService = MockAccountService(isLoggedIn: true)
        let memoRepository = MockMemoRepository(withError: MemoRepositoryError.network)
        let useCase = UpdateMemoUseCaseImpl(accountService: accountService, memoRepository: memoRepository)

        await assertThrows(
            try await useCase.invoke(memo: Memo.sample, text: "text", quote: "quote", page: 1, imageURLs: []),
            throws: UpdateMemoUseCaseError.badNetwork
        )
    }

    func testUpdateMemo() async {
        let accountService = MockAccountService(isLoggedIn: true)
        let memoRepository = MockMemoRepository()
        let useCase = UpdateMemoUseCaseImpl(accountService: accountService, memoRepository: memoRepository)

        do {
            try await useCase.invoke(memo: Memo.sample, text: "text", quote: "quote", page: 1, imageURLs: [])
            guard let updatedMemo = memoRepository.updatedMemo else {
                XCTFail("Must not be nil")
                return
            }

            XCTAssertEqual(updatedMemo.text, "text")
            XCTAssertEqual(updatedMemo.quote, "quote")
            XCTAssertEqual(updatedMemo.page, 1)
        } catch {
            XCTFail("Do not reach here")
        }
    }
}
