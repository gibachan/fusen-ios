//
//  PublicationResponse.swift
//  PublicationResponse
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import Foundation

struct PublicationResponse: Decodable {
    let kind: String
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
        let subtitle: String
        let authors: [String]
        let publishedDate: String
        let pageCount: Int
        let previewLink: String
    }
}

extension PublicationResponse {
    func toDomain() -> Publication? {
        guard let item = items.first else { return nil }
        return Publication(title: item.volumeInfo.title)
    }
}
