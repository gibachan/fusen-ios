//
//  MemoDraft.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/15.
//

import Foundation

public struct MemoDraft: Codable {
    public let id: ID<MemoDraft> = .init(value: UUID().uuidString)
    public let bookId: ID<Book>
    public let text: String
    public let quote: String
    public let page: Int?

    enum CodingKeys: String, CodingKey {
        case bookId = "book_id"
        case text
        case quote
        case page
      }

    public init(
        bookId: ID<Book>,
        text: String,
        quote: String,
        page: Int? = nil
    ) {
        self.bookId = bookId
        self.text = text
        self.quote = quote
        self.page = page
    }
}
