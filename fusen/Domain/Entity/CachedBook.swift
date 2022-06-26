//
//  CachedBook.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/06/25.
//

import Foundation

struct CachedBook: Codable {
    let id: ID<Book>
    let title: String
    let author: String
    let imageURL: URL?
}
