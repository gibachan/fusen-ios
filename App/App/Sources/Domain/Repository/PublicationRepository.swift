//
//  PublicationRepository.swift
//  PublicationRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import Foundation

public enum PublicationRepositoryError: Error {
    case notFound
    case invalidJSON
}

public protocol PublicationRepository {
    func findBy(isbn: ISBN) async throws -> Publication
    func findBy(title: String) async throws -> [Publication]
}
