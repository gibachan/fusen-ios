//
//  FirestoreUpdateMemo.swift
//  FirestoreUpdateMemo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import FirebaseFirestore
import Foundation

struct FirestoreUpdateMemo {
    let text: String
    let quote: String
    let page: Int?
    let imageURLs: [String]
    let updatedAt: FieldValue = .serverTimestamp()
}

extension FirestoreUpdateMemo {
    func data() -> [String: Any] {
        [
            "text": text,
            "quote": quote,
            "page": page ?? NSNull(),
            "imageURLs": imageURLs,
            "updatedAt": updatedAt
        ]
    }
}
