//
//  MemoRepository.swift
//  MemoRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

enum MemoRepositoryError: Error {
    case unknwon
}

protocol MemoRepository {
    func getLatestMemos(for user: User) async throws -> [Memo]

    func getAllMemos(for user: User, forceRefresh: Bool) async throws -> Pager<Memo>
    func getAllMemosNext(for user: User) async throws -> Pager<Memo>

    func getMemos(of book: Book, for user: User, forceRefresh: Bool) async throws -> Pager<Memo>
    func getNextMemos(of book: Book, for user: User) async throws -> Pager<Memo>

    func addMemo(of book: Book, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws -> ID<Memo>
    func update(memo: Memo, of book: Book, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws
    func delete(memo: Memo, of book: Book, for user: User) async throws
}

extension MemoRepository {
    func getAllMemos(for user: User, forceRefresh: Bool = false) async throws -> Pager<Memo> {
        return try await getAllMemos(for: user, forceRefresh: forceRefresh)
    }
}
