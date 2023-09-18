//
//  RakutenBooksResponse.swift
//  RakutenBooksResponse
//
//  Created by Tatsuyuki Kobayashi on 2021/08/30.
//

import Domain
import Foundation

struct RakutenBooksResponse: Decodable {
    let Items: [Item]
}

extension RakutenBooksResponse {
    struct Item: Decodable {
        let title: String
        let author: String
        let smallImageUrl: String
        let largeImageUrl: String
    }
}

extension RakutenBooksResponse.Item {
    func toPublication() -> Publication {
        return Publication(title: title, author: author, thumbnailURL: URL(string: largeImageUrl))
    }
}
