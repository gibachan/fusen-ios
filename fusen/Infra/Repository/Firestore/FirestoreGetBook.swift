//
//  FirestoreGetBook.swift
//  FirestoreGetBook
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import Foundation
import FirebaseFirestoreSwift

struct FirestoreGetBook: Codable {
    @DocumentID var id: String?
    let title: String
    let author: String
    let imageURL: String
    let description: String
    let impression: String
    let createdAt: Date
    let updatedAt: Date
    let isFavorite: Bool
    let valuation: Int
}

extension FirestoreGetBook {
    func toDomain() -> Book? {
        guard let id = id else { return nil }
        return Book(
            id: ID<Book>(value: id),
            title: title,
            author: author,
            imageURL: URL(string: imageURL),
            description: description,
            impression: impression,
            isFavorite: isFavorite,
            valuation: valuation
        )
    }
}
