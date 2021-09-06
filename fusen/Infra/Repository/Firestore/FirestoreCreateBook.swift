//
//  FirestoreCreateBook.swift
//  FirestoreCreateBook
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import Foundation
import FirebaseFirestore

struct FirestoreCreateBook {
    let title: String
    let author: String
    let imageURL: String
    let description: String
    let impression: String = ""
    let isFavorite: Bool = false
    let valuation: Int = 0
    let collectionId: String
    let createdAt: FieldValue = .serverTimestamp()
    let updatedAt: FieldValue = .serverTimestamp()
}

extension FirestoreCreateBook {
    static func fromDomain(
        publication: Publication,
        imageURL: URL?,
        collection: Collection?
    ) -> Self {
        
        return .init(
            title: publication.title,
            author: publication.author,
            imageURL: imageURL?.absoluteString ?? publication.thumbnailURL?.absoluteString ?? "",
            description: "",
            collectionId: collection?.id.value ?? ""
        )
    }
    
    func data() -> [String: Any] {
        [
            "title": title,
            "author": author,
            "imageURL": imageURL,
            "description": description,
            "impression": impression,
            "createdAt": createdAt,
            "updatedAt": updatedAt,
            "isFavorite": isFavorite,
            "valuation": valuation,
            "collectionId": collectionId
        ]
    }
}
