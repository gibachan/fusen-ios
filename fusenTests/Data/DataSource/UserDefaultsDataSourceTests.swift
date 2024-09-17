//
//  UserDefaultsDataSourceTests.swift
//  UserDefaultsDataSourceTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/15.
//

import Data
import Domain
@testable import fusen
import XCTest

class UserDefaultsDataSourceTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var dataSource: UserDefaultsDataSource!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults!.removePersistentDomain(forName: #file)
        dataSource = UserDefaultsDataSourceImpl(userDefaults: userDefaults!)
    }

    override func tearDown() {
        super.tearDown()
        userDefaults!.removePersistentDomain(forName: #file)
    }

    func testDidConfirmReadingBookDescription() {
        XCTAssertFalse(dataSource.didConfirmReadingBookDescription)
        dataSource.didConfirmReadingBookDescription = true
        XCTAssertTrue(dataSource.didConfirmReadingBookDescription)
    }

    func testReadBook() {
        let book = Book.sample
        XCTAssertEqual(dataSource.readBookPages.count, 0)
        XCTAssertNil(dataSource.getReadPage(for: book))
        dataSource.setReadPage(for: book, page: 10)
        XCTAssertEqual(dataSource.readBookPages.count, 1)
        XCTAssertEqual(dataSource.getReadPage(for: book), 10)
    }

    func testReadingBook() {
        XCTAssertNil(dataSource.readingBook)
        dataSource.readingBook = CachedBook(id: .init(stringLiteral: "1"), title: "A", author: "B", imageURL: URL(string: "https://example.com")!)
        let cachedBook = dataSource.readingBook
        XCTAssertEqual(cachedBook?.id, ID<Book>(stringLiteral: "1"))
        XCTAssertEqual(cachedBook?.title, "A")
        XCTAssertEqual(cachedBook?.author, "B")
        XCTAssertEqual(cachedBook?.imageURL, URL(string: "https://example.com"))
    }
}
