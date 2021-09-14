//
//  FirestoreGetBook.swift
//  FirestoreGetBook
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import FirebaseFirestore
import Foundation

struct FirestoreGetBook: Codable {
    let id: String
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
    static func from(id: String, data: [String: Any]?) -> Self? {
        guard let data = data else { return nil }
        guard let title = data["title"] as? String,
              let author = data["author"] as? String,
              let imageURL = data["imageURL"] as? String,
              let description = data["description"] as? String,
              let impression = data["impression"] as? String,
              let createdAt = data["createdAt"] as? Timestamp,
              let updatedAt = data["updatedAt"] as? Timestamp,
              let isFavorite = data["isFavorite"] as? Bool,
              let valuation = data["valuation"] as? Int,
              let collectionId = data["collectionId"] as? String else {
                  return nil
              }
              
        return FirestoreGetBook(
            id: id,
            title: title,
            author: author,
            imageURL: imageURL,
            description: description,
            impression: impression,
            createdAt: createdAt.dateValue(),
            updatedAt: updatedAt.dateValue(),
            isFavorite: isFavorite,
            valuation: valuation,
            collectionId: collectionId
        )
    }
 
    func toDomain() -> Book {
        return Book(
            id: ID<Book>(value: id),
            title: title,
            author: author,
            imageURL: URL(string: imageURL),
            description: description,
            impression: impression,
            isFavorite: isFavorite,
            valuation: valuation,
            collectionId: ID<Collection>(value: collectionId)
        )
    }
}
