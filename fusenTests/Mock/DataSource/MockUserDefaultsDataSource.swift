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
    private var _readingBookMemoDraft: MemoDraft?
    private var _reviewedVersion: String?
    private var _currentBookSort: BookSort?
    private var _currentMemoSort: MemoSort?
    private var _searchAPIKey: String?

    init(launchedAppBefore: Bool = false,
         didConfirmReadingBookDescription: Bool = false,
         readBookPages: [String: Any] = [:],
         readingBook: CachedBook? = nil,
         readingBookMemoDraft: MemoDraft? = nil,
         reviewedVersion: String? = nil,
         currentBookSort: BookSort? = nil,
         currentMemoSort: MemoSort? = nil,
         searchAPIKey: String? = nil) {
        self._launchedAppBefore = launchedAppBefore
        self._didConfirmReadingBookDescription = didConfirmReadingBookDescription
        self._readBookPages = readBookPages
        self._readingBook = readingBook
        self._readingBookMemoDraft = readingBookMemoDraft
        self._reviewedVersion = reviewedVersion
        self._currentBookSort = currentBookSort
        self._currentMemoSort = currentMemoSort
        self._searchAPIKey = searchAPIKey
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
    
    var readingBookMemoDraft: MemoDraft? {
        get { _readingBookMemoDraft }
        set { _readingBookMemoDraft = newValue }
    }
    
    var reviewedVersion: String? {
        get { _reviewedVersion }
        set { _reviewedVersion = newValue }
    }
    
    var currentMemoSort: MemoSort? {
        get { _currentMemoSort }
        set { _currentMemoSort = newValue }
    }
    
    var currentBookSort: BookSort? {
        get { _currentBookSort }
        set { _currentBookSort = newValue }
    }
    
    func getReadPage(for book: Book) -> Int? { nil }
    
    func setReadPage(for book: Book, page: Int) {}

    var searchAPIKey: String? {
        get { _searchAPIKey }
        set { _searchAPIKey = newValue }
    }
}
