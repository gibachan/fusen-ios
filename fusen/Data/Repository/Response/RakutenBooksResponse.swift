//
//  RakutenBooksResponse.swift
//  RakutenBooksResponse
//
//  Created by Tatsuyuki Kobayashi on 2021/08/30.
//

import Foundation

struct RakutenBooksResponse: Decodable {
    let Items: [Item]
}

extension RakutenBooksResponse {
    struct Item: Decodable {
        let title: String
        let author: String
        let smallImageUrl: String
    }
}

extension RakutenBooksResponse {
    func toDomain() -> Publication? {
        guard let item = Items.first else { return nil }
        
        return Publication(title: item.title, author: item.author, thumbnailURL: URL(string: item.smallImageUrl))
    }
}
