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
    let imageURL: String
    let description: String
    let impression: String = ""
    let createdAt: FieldValue = .serverTimestamp()
    let updatedAt: FieldValue = .serverTimestamp()
    let favorite: Bool = false
    let valuation: Int = 0
    
    static func fromDomain(_ publication: Publication) -> FirestoreCreateBook {
        return .init(
            title: publication.title,
            imageURL: publication.thumbnailURL?.absoluteString ?? "",
            description: ""
        )
    }
    
    func data() -> [String: Any] {
        [
            "title": title,
            "imageURL": imageURL,
            "description": description,
            "impression": impression,
            "createdAt": createdAt,
            "updatedAt": updatedAt,
            "favorite": favorite,
            "valuation": valuation,
        ]
    }
}
