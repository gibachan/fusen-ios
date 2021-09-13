//
//  QueryExtension.swift
//  QueryExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import FirebaseFirestore
import Foundation

extension Query {
    func whereBook(_ bookId: ID<Book>) -> Query {
        whereField("bookId", isEqualTo: bookId.value)
    }

    func whereIsFavorite(_ isFavorite: Bool) -> Query {
        whereField("isFavorite", isEqualTo: true)
    }

    func whereCollection(_ collection: Collection) -> Query {
        whereField("collectionId", isEqualTo: collection.id.value)
    }
    
    func orderByCreatedAtDesc() -> Query {
        order(by: "createdAt", descending: true)
    }

    func orderByTitleAsc() -> Query {
        order(by: "title", descending: false)
    }

    func orderByAuthorAsc() -> Query {
        order(by: "author", descending: false)
    }
    
    func orderByPageAsc() -> Query {
        order(by: "page", descending: false)
    }
}
