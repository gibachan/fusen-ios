//
//  Memo.swift
//  Memo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

struct Memo {
    let id: ID<Memo>
    let book: Book
    let text: String
    let quote: String
    let page: Int?
    let imageURLs: [URL]
    let createdAt: Date
    let updatedAt: Date
}
