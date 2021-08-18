//
//  Memo.swift
//  Memo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

struct Memo {
    let id: ID<Memo>
    let bookId: ID<Book>
    let text: String
    let quote: String
    let page: Int?
    let imageURLs: [URL]
    let createdAt: Date
    let updatedAt: Date
}

extension Memo {
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
