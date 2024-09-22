//
//  CollectionRepository.swift
//  CollectionRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

public enum CollectionRepositoryError: Error {
    case network
}

public protocol CollectionRepository {
    func getlCollections(for user: User) async throws -> [Collection]

    func addCollection(name: String, color: RGB, for user: User) async throws -> ID<Collection>

    func delete(collection: Collection, for user: User) async throws
}
