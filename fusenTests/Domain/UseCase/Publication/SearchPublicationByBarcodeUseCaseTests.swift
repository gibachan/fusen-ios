//
//  SearchPublicationByBarcodeUseCaseTests.swift
//  SearchPublicationByBarcodeUseCaseTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/06.
//

@testable import fusen
import XCTest

class SearchPublicationByBarcodeUseCaseTests: XCTestCase {
    func testUseRakutenBooksPrimarily() async {
        let analyticsService = MockAnalyticsService()
        let rakutenBooksPublicationRepository = MockPublicationRepository(result: .success(Publication.mock(title: "title1")))
        let googleBooksPublicationRepository = MockPublicationRepository(result: .success(Publication.mock(title: "title2")))
        let useCase = SearchPublicationByBarcodeUseCaseImpl(analyticsService: analyticsService, rakutenBooksPublicationRepository: rakutenBooksPublicationRepository, googleBooksPublicationRepository: googleBooksPublicationRepository)

        do {
            let result = try await useCase.invoke(barcode: ISBN.sample.value)
            switch result {
            case let .foundByRakutenBooks(publication):
                XCTAssertEqual(publication.title, "title1")
            case .foundByGoogleBooks:
                XCTFail("Not Supposed to be reached")
            }
        } catch {
            XCTFail("Not Supposed to be reached: \(error.localizedDescription)")
        }
    }
    func testUseGoogleBooksSecondarily() async {
        let analyticsService = MockAnalyticsService()
        let rakutenBooksPublicationRepository = MockPublicationRepository(result: .failure(.notFound))
        let googleBooksPublicationRepository = MockPublicationRepository(result: .success(Publication.mock(title: "title2")))
        let useCase = SearchPublicationByBarcodeUseCaseImpl(analyticsService: analyticsService, rakutenBooksPublicationRepository: rakutenBooksPublicationRepository, googleBooksPublicationRepository: googleBooksPublicationRepository)

        do {
            let result = try await useCase.invoke(barcode: ISBN.sample.value)
            switch result {
            case .foundByRakutenBooks:
                XCTFail("Not Supposed to be reached")
            case let .foundByGoogleBooks(publication):
                XCTAssertEqual(publication.title, "title2")
                XCTAssertEqual(analyticsService.loggedEvents, [AnalyticsEvent.scanBarcodeByRakutenError(code: ISBN.sample.value)])
            }
        } catch {
            XCTFail("Not Supposed to be reached: \(error.localizedDescription)")
        }
    }
    func testThrowsNotFoundException() async {
        let analyticsService = MockAnalyticsService()
        let rakutenBooksPublicationRepository = MockPublicationRepository(result: .failure(.notFound))
        let googleBooksPublicationRepository = MockPublicationRepository(result: .failure(.notFound))
        let useCase = SearchPublicationByBarcodeUseCaseImpl(analyticsService: analyticsService, rakutenBooksPublicationRepository: rakutenBooksPublicationRepository, googleBooksPublicationRepository: googleBooksPublicationRepository)

        do {
            _ = try await useCase.invoke(barcode: ISBN.sample.value)
            XCTFail("Not Supposed to be reached")
        } catch {
            switch error {
            case SearchPublicationByBarcodeUseCaseError.notFound:
                XCTAssertEqual(analyticsService.loggedEvents, [AnalyticsEvent.scanBarcodeByRakutenError(code: ISBN.sample.value), AnalyticsEvent.scanBarcodeByGoogleError(code: ISBN.sample.value)])
            default:
                XCTFail("Not Supposed to be reached")
            }
        }
    }
}

private final class MockAnalyticsService: AnalyticsServiceProtocol {
    var loggedEvents: [AnalyticsEvent] = []
    func log(event: AnalyticsEvent) {
        loggedEvents.append(event)
    }
}

private extension ISBN {
    static var sample: ISBN {
        return .iSBN13(value: "9784087604948")
    }
}

private extension Publication {
    static func mock(
        title: String = "",
        author: String = "",
        thumbnailURL: URL? = nil
    ) -> Publication {
        Publication(
            title: title,
            author: author,
            thumbnailURL: thumbnailURL
        )
    }
}

private struct MockPublicationRepository: PublicationRepository {
    let result: Result<Publication, PublicationRepositoryError>
    func findBy(isbn: ISBN) async throws -> Publication {
        switch result {
        case let .success(publication):
            return publication
        case let .failure(error):
            throw error
        }
    }
}
