//
//  GoogleBooksResponse.swift
//  GoogleBooksResponse
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import Domain
import Foundation

struct GoogleBooksResponse: Decodable {
    let totalItems: Int
    let items: [Item]
}

extension GoogleBooksResponse {
    struct Item: Decodable {
        let kind: String
        let id: String
        let volumeInfo: VolumeInfo
    }
}

extension GoogleBooksResponse.Item {
    struct VolumeInfo: Decodable {
        let title: String
        let subtitle: String?
        let authors: [String]
        let publishedDate: String
        let pageCount: Int
        let imageLinks: ImageLink?
    }
}

extension GoogleBooksResponse.Item.VolumeInfo {
    struct ImageLink: Decodable {
        let thumbnail: String
    }
}

extension GoogleBooksResponse {
    func toDomain() -> Publication? {
        guard let item = items.first else { return nil }

        var thumbnailURL: URL?
        if let thumbnail = item.volumeInfo.imageLinks?.thumbnail {
            // http -> https 変換
            let thumbnailString = thumbnail.replacingOccurrences(of: "http://", with: "https://")
            thumbnailURL = URL(string: thumbnailString)
        }

        return Publication(
            title: item.volumeInfo.title,
            author: item.volumeInfo.authors.joined(separator: ","),
            thumbnailURL: thumbnailURL
        )
    }
}
