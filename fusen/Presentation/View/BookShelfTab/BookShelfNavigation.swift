//
//  BookShelfNavigation.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2021/09/15.
//

import Foundation

enum BookShelfNavigation {
    case none
    case book(book: Book)
    case allBooks
    case favoriteBookList
    case collection(collection: Collection)
}
