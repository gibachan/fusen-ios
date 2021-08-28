//
//  FirestoreGetMemo.swift
//  FirestoreGetMemo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation
import FirebaseFirestore

struct FirestoreGetMemo: Codable {
    let id: String
    let bookId: String
    let text: String
    let quote: String
    let page: Int?
    let imageURLs: [URL]
    let createdAt: Date
    let updatedAt: Date
}

extension FirestoreGetMemo {
    static func from(id: String, data: [String: Any]?) -> Self? {
        guard let data = data else { return nil }
        guard let bookId = data["bookId"] as? String,
              let text = data["text"] as? String,
              let quote = data["quote"] as? String,
              let imageURLs = data["imageURLs"] as? [String],
              let createdAt = data["createdAt"] as? Timestamp,
              let updatedAt = data["updatedAt"] as? Timestamp else {
                  return nil
              }
        
        let page = data["page"] as? Int
        return FirestoreGetMemo(
            id: id,
            bookId: bookId,
            text: text,
            quote: quote,
            page: page,
            imageURLs: imageURLs.compactMap { URL(string: $0) },
            createdAt: createdAt.dateValue(),
            updatedAt: updatedAt.dateValue()
        )
    }
    
    func toDomain() -> Memo {
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
