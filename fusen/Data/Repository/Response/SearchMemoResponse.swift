//
//  SearchMemoResponse.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/27.
//

import AlgoliaSearchClient
import Foundation

struct SearchMemoResponse: Decodable {
    let objectID: String
    let text: String
    let quote: String
    let bookId: String
    let page: Int?
    let imageURLs: [URL]
    let createdAt: Date
    let updatedAt: Date
    let tags: [String]
}

extension SearchMemoResponse {
    func toMemo() -> Memo {
        Memo(
            id: .init(value: objectID),
            bookId: .init(value: bookId),
            text: text,
            quote: quote,
            page: page,
            imageURLs: imageURLs,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
