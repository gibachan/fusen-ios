//
//  FirestoreCreateMemo.swift
//  FirestoreCreateMemo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import FirebaseFirestore
import Foundation

struct FirestoreCreateMemo {
    let bookId: String
    let text: String
    let quote: String
    let page: Int?
    let imageURLs: [String]
    let createdAt: FieldValue = .serverTimestamp()
    let updatedAt: FieldValue = .serverTimestamp()
}

extension FirestoreCreateMemo {
    func data() -> [String: Any] {
        [
            "bookId": bookId,
            "text": text,
            "quote": quote,
            "page": page ?? NSNull(),
            "tags": [String](),
            "imageURLs": imageURLs,
            "createdAt": createdAt,
            "updatedAt": updatedAt
        ]
    }
}
