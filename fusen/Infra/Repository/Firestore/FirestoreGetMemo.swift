//
//  FirestoreGetMemo.swift
//  FirestoreGetMemo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation
import FirebaseFirestoreSwift

struct FirestoreGetMemo: Codable {
    @DocumentID var id: String?
    let bookId: String
    let text: String
    let quote: String
    let page: Int?
    let imageURLs: [URL]
    let createdAt: Date
    let updatedAt: Date
}

extension FirestoreGetMemo {
    func toDomain() -> Memo? {
        guard let id = id else { return nil }
        return Memo(
            id: ID<Memo>(value: id),
            bookId: ID<Book>(value: bookId),
            text: text,
            quote: quote,
            page: page,
            imageURLs: imageURLs,
            createdAt: createdAt,
            updatedAt: createdAt
        )
    }
}
