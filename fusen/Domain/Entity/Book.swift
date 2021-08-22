//
//  Book.swift
//  Book
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

struct Book {
    let id: ID<Book>
    let title: String
    let author: String
    let imageURL: URL?
    let description: String
    let impression: String
    let isFavorite: Bool
    let valuation: Int
    let collectionId: ID<Collection>
}

extension Book {
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
