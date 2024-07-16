//
//  FirestoreGetMemo.swift
//  FirestoreGetMemo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Domain
import FirebaseFirestore
import Foundation

struct FirestoreGetMemo: Codable {
    let bookId: String
    let text: String
    let quote: String
    let page: Int?
    let imageURLs: [URL]
    let createdAt: Date
    let updatedAt: Date
}

extension FirestoreGetMemo {
    func toDomain(id: String) -> Memo {
        return Memo(
            id: ID<Memo>(stringLiteral: id),
            bookId: ID<Book>(stringLiteral: bookId),
            text: text,
            quote: quote,
            page: page,
            imageURLs: imageURLs,
            createdAt: createdAt,
            updatedAt: createdAt
        )
    }
}
