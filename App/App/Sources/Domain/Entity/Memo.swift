//
//  Memo.swift
//  Memo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

public struct Memo {
    public let id: ID<Memo>
    public let bookId: ID<Book>
    public let text: String
    public let quote: String
    public let page: Int?
    public let imageURLs: [URL]
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: ID<Memo>,
        bookId: ID<Book>,
        text: String,
        quote: String,
        page: Int? = nil,
        imageURLs: [URL],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.bookId = bookId
        self.text = text
        self.quote = quote
        self.page = page
        self.imageURLs = imageURLs
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Memo: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

public extension Memo {
    static var sample: Memo {
        Memo(
            id: ID<Memo>(value: "memo"),
            bookId: Book.sample.id,
            text: "hoge",
            quote: "piyo",
            page: 1,
            imageURLs: [],
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}
