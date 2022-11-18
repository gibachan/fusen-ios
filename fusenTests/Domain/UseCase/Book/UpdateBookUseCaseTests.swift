//
//  UpdateBookUseCaseTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/11/18.
//

@testable import fusen
import XCTest

class UpdateBookUseCaseTests: XCTestCase {
    func testUpdateBookData() async throws {
        let accountService = MockAccountService(isLoggedIn: true)
        let bookRepository = MockBookRepository()
        let useCase = UpdateBookUseCaseImpl(accountService: accountService,
                                            bookRepository: bookRepository)
        
        try await useCase.invoke(book: Book.sample,
                                 image: nil,
                                 title: "New title",
                                 author: "New author",
                                 description: "New description")

        XCTAssertFalse(bookRepository.isBookImageUpdated)
        XCTAssertTrue(bookRepository.isBookDataUpdated)
    }
    
    func testUpdateBookImage() async throws {
        let accountService = MockAccountService(isLoggedIn: true)
        let bookRepository = MockBookRepository()
        let useCase = UpdateBookUseCaseImpl(accountService: accountService,
                                            bookRepository: bookRepository)
        
        try await useCase.invoke(book: Book.sample,
                                 image: ImageData(type: .book, data: Data()),
                                 title: "New title",
                                 author: "New author",
                                 description: "New description")

        XCTAssertTrue(bookRepository.isBookImageUpdated)
        XCTAssertTrue(bookRepository.isBookDataUpdated)
    }
}
