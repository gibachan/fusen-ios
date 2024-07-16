//
//  CachedBook.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/06/25.
//

import Foundation

public struct CachedBook: Codable {
    public let id: ID<Book>
    public let title: String
    public let author: String
    public let imageURL: URL?

    public init(
        id: ID<Book>,
        title: String,
        author: String,
        imageURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.imageURL = imageURL
    }
}
