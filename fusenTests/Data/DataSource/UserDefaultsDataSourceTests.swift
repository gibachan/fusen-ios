//
//  UserDefaultsDataSourceTests.swift
//  UserDefaultsDataSourceTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/15.
//

import Foundation

@testable import fusen
import XCTest

class UserDefaultsDataSourceTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var dataSource: UserDefaultsDataSource!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults!.removePersistentDomain(forName: #file)
        dataSource = UserDefaultsDataSource(userDefaults: userDefaults!)
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
}
