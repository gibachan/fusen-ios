//
//  MemoDraft.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/15.
//

import Foundation

struct MemoDraft: Codable {
    let id: ID<MemoDraft> = .init(value: UUID().uuidString)
    let bookId: ID<Book>
    let text: String
    let quote: String
    let page: Int?
    
    enum CodingKeys: String, CodingKey {
        case bookId = "book_id"
        case text
        case quote
        case page
      }
}
