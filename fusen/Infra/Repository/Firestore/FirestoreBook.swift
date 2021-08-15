//
//  FirestoreBook.swift
//  FirestoreBook
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import Foundation
import FirebaseFirestoreSwift

struct FirestoreBook: Codable {
    @DocumentID var id: String?
    let title: String
}

extension FirestoreBook {
    func toDomain() -> Book? {
        guard let id = id else { return nil }
        return Book(id: ID<Book>(value: id), title: title)
    }
}
