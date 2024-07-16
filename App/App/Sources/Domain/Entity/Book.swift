//
//  Book.swift
//  Book
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

public struct Book {
    public let id: ID<Book>
    public let title: String
    public let author: String
    public let imageURL: URL?
    public let description: String
    public let impression: String
    public let isFavorite: Bool
    public let valuation: Int
    public let collectionId: ID<Collection>

    public init(
        id: ID<Book>,
        title: String,
        author: String,
        imageURL: URL? = nil,
        description: String,
        impression: String,
        isFavorite: Bool,
        valuation: Int,
        collectionId: ID<Collection>
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.imageURL = imageURL
        self.description = description
        self.impression = impression
        self.isFavorite = isFavorite
        self.valuation = valuation
        self.collectionId = collectionId
    }
}

extension Book: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

public extension Book {
    static var sample: Book {
        Book(
            id: ID(value: "hoge"),
            title: "星の王子さま",
            author: "サン=テグジュペリ",
            imageURL: URL(string: "https://books.google.com/books/content?id=1st0QgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
            description: "書籍の説明",
            impression: "本を読んだ感想・本を読んだ感想・本を読んだ感想・本を読んだ感想・本を読んだ感想・本を読んだ感想\nGreat book I've ever read!",
            isFavorite: true,
            valuation: 3,
            collectionId: Collection.sample.id
        )
    }
}
