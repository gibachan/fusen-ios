//
//  BookShelfColumn.swift
//  BookShelfColumn
//
//  Created by Tatsuyuki Kobayashi on 2021/09/10.
//

import Domain
import Foundation

struct BookShelfColumn: Identifiable {
    let id: String
    let books: [Book]
}
