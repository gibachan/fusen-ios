//
//  PublicationResponse.swift
//  PublicationResponse
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import Foundation

struct PublicationResponse: Decodable {
    let totalItems: Int
    let items: [Item]
}

extension PublicationResponse {
    struct Item: Decodable {
        let kind: String
        let id: String
        let volumeInfo: VolumeInfo
    }
}

extension PublicationResponse.Item {
    struct VolumeInfo: Decodable {
        let title: String
        let subtitle: String?
        let authors: [String]
        let publishedDate: String
        let pageCount: Int
        let imageLinks: ImageLink?
    }
}

extension PublicationResponse.Item.VolumeInfo {
    struct ImageLink: Decodable {
        let thumbnail: String
    }
}

extension PublicationResponse {
    func toDomain() -> Publication? {
        guard let item = items.first else { return nil }
        if let thumbnail = item.volumeInfo.imageLinks?.thumbnail {
            return Publication(title: item.volumeInfo.title, thumbnailURL: URL(string: thumbnail))
        } else {
            return Publication(title: item.volumeInfo.title, thumbnailURL: nil)
        }
    }
}
