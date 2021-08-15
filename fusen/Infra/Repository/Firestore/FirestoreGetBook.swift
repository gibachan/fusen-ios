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
    let imageURL: String
    let description: String
    let impression: String
    let createdAt: Date
    let updatedAt: Date
    let favorite: Bool
    let valuation: Int
}

extension FirestoreGetBook {
    func toDomain() -> Book? {
        guard let id = id else { return nil }
        return Book(
            id: ID<Book>(value: id),
            title: title,
            imageURL: URL(string: imageURL)
        )
    }
}
