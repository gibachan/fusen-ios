//
//  SearchPublicationByBarcodeUseCase.swift
//  SearchPublicationByBarcodeUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum SearchPublicationByBarcodeUseCaseResult {
    case foundByRakutenBooks(publication: Publication)
    case foundByGoogleBooks(publication: Publication)
}

enum SearchPublicationByBarcodeUseCaseError: Error {
    case invalidBarcode
    case notFound
}

protocol SearchPublicationByBarcodeUseCase {
    func invoke(barcode: String) async throws -> SearchPublicationByBarcodeUseCaseResult
}

final class SearchPublicationByBarcodeUseCaseImpl: SearchPublicationByBarcodeUseCase {
    private let analyticsService: AnalyticsServiceProtocol
    private let rakutenBooksPublicationRepository: PublicationRepository
    private let googleBooksPublicationRepository: PublicationRepository
    
    init(
        analyticsService: AnalyticsServiceProtocol = AnalyticsService.shared,
        rakutenBooksPublicationRepository: PublicationRepository = RakutenBooksPublicationRepositoryImpl(),
        googleBooksPublicationRepository: PublicationRepository = GoogleBooksPublicationRepositoryImpl()
    ) {
        self.analyticsService = analyticsService
        self.rakutenBooksPublicationRepository = rakutenBooksPublicationRepository
        self.googleBooksPublicationRepository = googleBooksPublicationRepository
    }
    
    func invoke(barcode: String) async throws -> SearchPublicationByBarcodeUseCaseResult {
        guard let isbn = ISBN.from(code: barcode) else {
            throw SearchPublicationByBarcodeUseCaseError.invalidBarcode
        }
        
        do {
            let publication = try await rakutenBooksPublicationRepository.findBy(isbn: isbn)
            return .foundByRakutenBooks(publication: publication)
        } catch {
            analyticsService.log(event: .scanBarcodeByRakutenError(code: barcode))
            
            do {
                let publication = try await googleBooksPublicationRepository.findBy(isbn: isbn)
                return .foundByGoogleBooks(publication: publication)
            } catch {
                analyticsService.log(event: .scanBarcodeByGoogleError(code: barcode))
                throw SearchPublicationByBarcodeUseCaseError.notFound
            }
        }
    }
}
