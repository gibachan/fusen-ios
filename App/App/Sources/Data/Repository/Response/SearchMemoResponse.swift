//
//  SearchMemoResponse.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/27.
//

import AlgoliaSearchClient
import Foundation

struct SearchMemoResponse: Decodable {
    let objectID: String
    let updatedAt: Int
}
