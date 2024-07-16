//
//  FirestoreGetBook.swift
//  FirestoreGetBook
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import Domain
import FirebaseFirestore
import Foundation

struct FirestoreGetBook: Codable {
    let title: String
    let author: String
    let imageURL: String
    let description: String
    let impression: String
    let createdAt: Date
    let updatedAt: Date
    let isFavorite: Bool
    let valuation: Int
    let collectionId: String
}

extension FirestoreGetBook {
    func toDomain(id: String) -> Book {
        return Book(
            id: ID<Book>(stringLiteral: id),
            title: title,
            author: author,
            imageURL: URL(string: imageURL),
            description: description,
            impression: impression,
            isFavorite: isFavorite,
            valuation: valuation,
            collectionId: ID<Collection>(stringLiteral: collectionId)
        )
    }
}
