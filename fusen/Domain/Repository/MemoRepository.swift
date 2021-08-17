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
    func addMemo(of book: Book, text: String, quote: String, page: Int?, imageURLs: [URL], for user: User) async throws -> ID<Memo>
}
