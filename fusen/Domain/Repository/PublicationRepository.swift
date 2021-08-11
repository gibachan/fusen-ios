//
//  PublicationRepository.swift
//  PublicationRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import Foundation

enum PublicationRepositoryError: Error {
    case notFound
    case invalidJSON
}

protocol PublicationRepository {
    func findBy(isbn: String) async throws -> Publication
}
