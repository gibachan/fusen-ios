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

private class MockMemoRepository: MemoRepository {
    private let error: MemoRepositoryError?
    var addedMemo: Memo?
    
    init() {
        error = nil
    }
    
    init(withError error: MemoRepositoryError) {
        self.error = error
    }
    
    func getLatestMemos(count: Int, for user: User) async throws -> [Memo] {
        fatalError("Not implemented yet")
    }
    
    func getAllMemos(for user: User, forceRefresh: Bool) async throws -> Pager<Memo> {
        fatalError("Not implemented yet")
    }
    
    func getAllMemosNext(for user: User) async throws -> Pager<Memo> {
        fatalError("Not implemented yet")
    }
    
    func getMemos(of bookId: ID<Book>, sortedBy: MemoSort, for user: User, forceRefresh: Bool) async throws -> Pager<Memo> {
        fatalError("Not implemented yet")
    }
    
    func getNextMemos(of bookId: ID<Book>, for user: User) async throws -> Pager<Memo> {
        fatalError("Not implemented yet")
    }
    
    func addMemo(of book: Book, text: String, quote: String, page: Int?, image: ImageData?, for user: User) async throws -> ID<Memo> {
        if let error = error {
            throw error
        }
        
        let newMemo = Memo(id: ID<Memo>(value: UUID().uuidString), bookId: book.id, text: text, quote: quote, page: page, imageURLs: [], createdAt: Date(), updatedAt: Date())
        addedMemo = newMemo
        return newMemo.id
    }
    
    func update(memo: Memo, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws {
        fatalError("Not implemented yet")
    }
    
    func delete(memo: Memo, for user: User) async throws {
        fatalError("Not implemented yet")
    }
}
