//
//  AddMemoUseCaseTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/20.
//

import XCTest

@testable import fusen

class AddMemoUseCaseTests: XCTestCase {
    func testThrowsNotAuthenticated() async {
        let accountService = MockAccountService(isLoggedIn: false)
        let memoRepository = MockMemoRepository()
        let useCase = AddMemoUseCaseImpl(accountService: accountService, memoRepository: memoRepository)
        
        await assertThrows(
            try await useCase.invoke(book: Book.sample, text: "text", quote: "quote", page: 1, image: nil),
            throws: AddMemoUseCaseError.notAuthenticated
        )
    }
    
    func testBadNetowrkError() async {
        let accountService = MockAccountService(isLoggedIn: true)
        let memoRepository = MockMemoRepository(withError: MemoRepositoryError.uploadImage)
        let useCase = AddMemoUseCaseImpl(accountService: accountService, memoRepository: memoRepository)
        
        await assertThrows(
            try await useCase.invoke(book: Book.sample, text: "text", quote: "quote", page: 1, image: nil),
            throws: AddMemoUseCaseError.badNetwork
        )
    }
    
    func testAddMemo() async {
        let accountService = MockAccountService(isLoggedIn: true)
        let memoRepository = MockMemoRepository()
        let useCase = AddMemoUseCaseImpl(accountService: accountService, memoRepository: memoRepository)
        
        do {
            _ = try await useCase.invoke(book: Book.sample, text: "text", quote: "quote", page: 0, image: nil)
            guard let addedMemo = memoRepository.addedMemo else {
                XCTFail("Must not be nil")
                return
            }
            
            XCTAssertEqual(addedMemo.text, "text")
            XCTAssertEqual(addedMemo.quote, "quote")
            XCTAssertNil(addedMemo.page)
        } catch {
            XCTFail("Do not reach here")
        }
    }
}
