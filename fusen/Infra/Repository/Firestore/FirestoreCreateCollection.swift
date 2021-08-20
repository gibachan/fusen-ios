//
//  FirestoreCreateCollection.swift
//  FirestoreCreateCollection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import Foundation
import FirebaseFirestore

struct FirestoreCreateCollection {
    let name: String
    let color: [Int]
    let createdAt: FieldValue = .serverTimestamp()
}

extension FirestoreCreateCollection {
    func data() -> [String: Any] {
        [
            "name": name,
            "color": color,
            "createdAt": createdAt
        ]
    }
}
