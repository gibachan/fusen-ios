//
//  FirestoreUpdateUser.swift
//  FirestoreUpdateUser
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Foundation
import FirebaseFirestore

struct FirestoreUpdateUser {
    let readingBookId: String
    let updatedAt: FieldValue = .serverTimestamp()
}

extension FirestoreUpdateUser {
    func data() -> [String: Any] {
        [
            "readingBookId": readingBookId,
            "updatedAt": updatedAt,
        ]
    }
}
