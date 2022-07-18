//
//  MockUserDefaultsDataSource.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/06/25.
//

import Foundation
@testable import fusen

final class MockUserDefaultsDataSource: UserDefaultsDataSource {
    private var _launchedAppBefore: Bool
    private var _didConfirmReadingBookDescription: Bool
    private var _readBookPages: [String: Any]
    private var _readingBook: CachedBook?
    private var _reviewedVersion: String?
    private var _currentMemoSort: MemoSort?

    init(launchedAppBefore: Bool = false,
         didConfirmReadingBookDescription: Bool = false,
         readBookPages: [String: Any] = [:],
         readingBook: CachedBook? = nil,
         reviewedVersion: String? = nil,
         currentMemoSort: MemoSort? = nil) {
        self._launchedAppBefore = launchedAppBefore
        self._didConfirmReadingBookDescription = didConfirmReadingBookDescription
        self._readBookPages = readBookPages
        self._readingBook = readingBook
        self._reviewedVersion = reviewedVersion
        self._currentMemoSort = nil
    }
    
    var launchedAppBefore: Bool {
        get { _launchedAppBefore }
        set { _launchedAppBefore = newValue }
    }
    
    var didConfirmReadingBookDescription: Bool {
        get { _didConfirmReadingBookDescription }
        set { _didConfirmReadingBookDescription = newValue }
    }
    
    var readBookPages: [String: Any] {
        get { _readBookPages }
        set { _readBookPages = newValue }
    }
    
    var readingBook: CachedBook? {
        get { _readingBook }
        set { _readingBook = newValue }
    }
    
    var reviewedVersion: String? {
        get { _reviewedVersion }
        set { _reviewedVersion = newValue }
    }
    
    var currentMemoSort: MemoSort? {
        get { _currentMemoSort }
        set { _currentMemoSort = newValue }
    }
    
    func getReadPage(for book: Book) -> Int? { nil }
    
    func setReadPage(for book: Book, page: Int) {}
}
