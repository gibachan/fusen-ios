//
//  SearchPublicationsByTitleUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import Foundation

public enum SearchPublicationsByTitleUseCaseError: Error {
    case notFound
}

public protocol SearchPublicationsByTitleUseCase {
    func invoke(withTitle title: String) async throws -> [Publication]
}

public final class SearchPublicationsByTitleUseCaseImpl: SearchPublicationsByTitleUseCase {
    private let rakutenBooksPublicationRepository: PublicationRepository

    public init(rakutenBooksPublicationRepository: PublicationRepository) {
        self.rakutenBooksPublicationRepository = rakutenBooksPublicationRepository
    }

    public func invoke(withTitle title: String) async throws -> [Publication] {
        guard title.isNotEmpty else {
            throw SearchPublicationsByTitleUseCaseError.notFound
        }

        do {
            let publications = try await rakutenBooksPublicationRepository.findBy(title: title)
            guard publications.isNotEmpty else {
                throw SearchPublicationsByTitleUseCaseError.notFound
            }
            return publications
        } catch {
            throw SearchPublicationsByTitleUseCaseError.notFound
        }
    }
}

// FIXME: Remove duplicated code
private extension Array {
    var isNotEmpty: Bool { !isEmpty }
}

// FIXME: Remove duplicated code
private extension String {
    var isNotEmpty: Bool {
        !isEmpty
    }
}
