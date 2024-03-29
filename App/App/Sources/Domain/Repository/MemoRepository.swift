//
//  MemoRepository.swift
//  MemoRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

public enum MemoRepositoryError: Error {
    case uploadImage
    case network
}

public protocol MemoRepository {
    func getDraft() async -> MemoDraft?
    func setDraft(_ draft: MemoDraft?) async

    func getMemo(by id: ID<Memo>, for user: User) async throws -> Memo

    func getLatestMemos(count: Int, for user: User) async throws -> [Memo]

    func getAllMemos(for user: User, forceRefresh: Bool) async throws -> Pager<Memo>
    func getAllMemosNext(for user: User) async throws -> Pager<Memo>

    func getMemos(of bookId: ID<Book>, sortedBy: MemoSort, for user: User, forceRefresh: Bool) async throws -> Pager<Memo>
    func getNextMemos(of bookId: ID<Book>, for user: User) async throws -> Pager<Memo>

    func addMemo(bookId: ID<Book>, text: String, quote: String, page: Int?, image: ImageData?, for user: User) async throws -> ID<Memo>
    func update(memo: Memo, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws
    func delete(memo: Memo, for user: User) async throws
}
