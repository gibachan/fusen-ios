//
//  FirestoreCreateCollection.swift
//  FirestoreCreateCollection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import FirebaseFirestore
import Foundation

struct FirestoreCreateCollection {
    let color: [Int]
    let createdAt: FieldValue = .serverTimestamp()
}

extension FirestoreCreateCollection {
    func data() -> [String: Any] {
        [
            "color": color,
            "createdAt": createdAt
        ]
    }
}
