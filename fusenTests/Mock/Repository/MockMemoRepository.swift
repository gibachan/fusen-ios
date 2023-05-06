//
//  MockMemoRepository.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/22.
//

import Foundation
@testable import fusen

class MockMemoRepository: MemoRepository {
    private let error: MemoRepositoryError?
    var addedMemo: Memo?
    var updatedMemo: Memo?
    
    init() {
        error = nil
    }
    
    init(withError error: MemoRepositoryError) {
        self.error = error
    }

    func getDraft() async -> MemoDraft? {
        fatalError("Not implemented yet")
    }
    
    func setDraft(_ draft: MemoDraft?) async {
        fatalError("Not implemented yet")
    }

    func getMemo(by id: fusen.ID<fusen.Memo>, for user: fusen.User) async throws -> fusen.Memo {
        fatalError("Not implemented yet")
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
    
    func addMemo(bookId: ID<Book>, text: String, quote: String, page: Int?, image: ImageData?, for user: User) async throws -> ID<Memo> {
        if let error = error {
            throw error
        }
        
        let newMemo = Memo(id: ID<Memo>(value: UUID().uuidString), bookId: bookId, text: text, quote: quote, page: page, imageURLs: [], createdAt: Date(), updatedAt: Date())
        addedMemo = newMemo
        return newMemo.id
    }
    
    func update(memo: Memo, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws {
        if let error = error {
            throw error
        }
        
        updatedMemo = Memo(id: memo.id, bookId: memo.bookId, text: text, quote: quote, page: page, imageURLs: imageURLs, createdAt: memo.createdAt, updatedAt: memo.updatedAt)
    }
    
    func delete(memo: Memo, for user: User) async throws {
        fatalError("Not implemented yet")
    }
}
