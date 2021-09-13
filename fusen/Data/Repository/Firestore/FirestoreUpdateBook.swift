//
//  FirestoreUpdateBook.swift
//  FirestoreUpdateBook
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import FirebaseFirestore
import Foundation

struct FirestoreUpdateBook {
    let title: String
    let author: String
    let imageURL: String
    let description: String
    var impression: String
    let updatedAt: FieldValue = .serverTimestamp()
    let isFavorite: Bool
    let valuation: Int
    let collectionId: String
}

extension FirestoreUpdateBook {
    func data() -> [String: Any] {
        [
            "title": title,
            "author": author,
            "imageURL": imageURL,
            "description": description,
            "impression": impression,
            "updatedAt": updatedAt,
            "isFavorite": isFavorite,
            "valuation": valuation,
            "collectionId": collectionId
        ]
    }
}
