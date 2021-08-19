//
//  CollectionRepository.swift
//  CollectionRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

enum CollectionRepositoryError: Error {
    case unknwon
}

protocol CollectionRepository {
    func getlCollections(for user: User) async throws -> [Collection]
}
