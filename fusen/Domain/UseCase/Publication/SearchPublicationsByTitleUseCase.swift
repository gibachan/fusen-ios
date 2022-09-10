//
//  SearchPublicationsByTitleUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import Foundation

enum SearchPublicationsByTitleUseCaseError: Error {
    case notFound
}

protocol SearchPublicationsByTitleUseCase {
    func invoke(withTitle title: String) async throws -> [Publication]
}

final class SearchPublicationsByTitleUseCaseImpl: SearchPublicationsByTitleUseCase {
    private let rakutenBooksPublicationRepository: PublicationRepository
    
    init(rakutenBooksPublicationRepository: PublicationRepository = RakutenBooksPublicationRepositoryImpl()) {
        self.rakutenBooksPublicationRepository = rakutenBooksPublicationRepository
    }
    
    func invoke(withTitle title: String) async throws -> [Publication] {
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
