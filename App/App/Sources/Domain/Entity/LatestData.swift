//
//  LatestData.swift
//  LatestData
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public struct LatestData {
    public let books: [Book]
    public let memos: [Memo]

    public init(books: [Book], memos: [Memo]) {
        self.books = books
        self.memos = memos
    }
}
