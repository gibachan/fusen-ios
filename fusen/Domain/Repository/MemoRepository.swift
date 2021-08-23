//
//  MemoRepository.swift
//  MemoRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

enum MemoRepositoryError: Error {
    case uploadImage
    case unknown
}

protocol MemoRepository {
    func getLatestMemos(for user: User) async throws -> [Memo]

    func getAllMemos(for user: User, forceRefresh: Bool) async throws -> Pager<Memo>
    func getAllMemosNext(for user: User) async throws -> Pager<Memo>

    func getMemos(of bookId: ID<Book>, for user: User, forceRefresh: Bool) async throws -> Pager<Memo>
    func getNextMemos(of bookId: ID<Book>, for user: User) async throws -> Pager<Memo>

    func addMemo(of book: Book, text: String, quote: String, page: Int?, image: ImageData?, for user: User) async throws -> ID<Memo>
    func update(memo: Memo, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws
    func delete(memo: Memo, for user: User) async throws
}

extension MemoRepository {
    func getAllMemos(for user: User, forceRefresh: Bool = false) async throws -> Pager<Memo> {
        return try await getAllMemos(for: user, forceRefresh: forceRefresh)
    }
}
