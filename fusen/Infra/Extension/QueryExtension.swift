//
//  QueryExtension.swift
//  QueryExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation
import FirebaseFirestore

extension Query {
    func whereBook(_ book: Book) -> Query {
        whereField("bookId", isEqualTo: book.id.value)
    }
    
    func whereCollection(_ collection: Collection) -> Query {
        whereField("collectionId", isEqualTo: collection.id.value)
    }
    
    func orderByCreatedAtDesc() -> Query {
        order(by: "createdAt", descending: true)
    }
}
