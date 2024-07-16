//
//  UserDefaultsDataSource.swift
//  UserDefaultsDataSource
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Domain
import Foundation

public protocol UserDefaultsDataSource: AnyObject {
    var launchedAppBefore: Bool { get set }
    var didConfirmReadingBookDescription: Bool { get set }
    var readBookPages: [String: Any] { get }
    var readingBook: CachedBook? { get set }
    var readingBookMemoDraft: MemoDraft? { get set }
    var reviewedVersion: String? { get set }
    var currentBookSort: BookSort? { get set }
    var currentMemoSort: MemoSort? { get set }
    var searchAPIKey: String? { get set }

    func getReadPage(for book: Book) -> Int?
    func setReadPage(for book: Book, page: Int)
}

public final class UserDefaultsDataSourceImpl: UserDefaultsDataSource {
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .init(suiteName: "group.app.fusen")!) {
        self.userDefaults = userDefaults
    }
    
    public var launchedAppBefore: Bool {
        get {
            userDefaults.bool(forKey: .launchedAppBefore)
        }
        set {
            userDefaults.set(newValue, forKey: .launchedAppBefore)
        }
    }
    
    public var didConfirmReadingBookDescription: Bool {
        get {
            userDefaults.bool(forKey: .didConfirmReadingBookDescription)
        }
        set {
            userDefaults.set(newValue, forKey: .didConfirmReadingBookDescription)
        }
    }
    
    public var readBookPages: [String: Any] {
        userDefaults.dictionary(forKey: .readBook)
    }
    
    public var readingBook: CachedBook? {
        get {
            return userDefaults.decodableObject(forKey: .readingBook)
        }
        set {
            userDefaults.setEncodable(newValue, forKey: .readingBook)
        }
    }
    
    public var readingBookMemoDraft: MemoDraft? {
        get {
            return userDefaults.decodableObject(forKey: .readingBookMemoDrafts)
        }
        set {
            userDefaults.setEncodable(newValue, forKey: .readingBookMemoDrafts)
        }
    }
    
    public func getReadPage(for book: Book) -> Int? {
        let readBook = userDefaults.dictionary(forKey: .readBook)
        return readBook[book.id.value] as? Int
    }
    
    public func setReadPage(for book: Book, page: Int) {
        var readBook = userDefaults.dictionary(forKey: .readBook)
        readBook[book.id.value] = page
        userDefaults.set(readBook, forKey: .readBook)
    }
    
    public var reviewedVersion: String? {
        get {
            userDefaults.string(forKey: .reviewedVersion)
        }
        set {
            userDefaults.set(newValue, forKey: .reviewedVersion)
        }
    }
    
    public var currentBookSort: BookSort? {
        get {
            guard let value = userDefaults.string(forKey: .bookSort) else { return nil }
            return BookSort(rawValue: value)
        }
        set {
            userDefaults.set(newValue?.rawValue, forKey: .bookSort)
        }
    }
    
    public var currentMemoSort: MemoSort? {
        get {
            guard let value = userDefaults.string(forKey: .memoSort) else { return nil }
            return MemoSort(rawValue: value)
        }
        set {
            userDefaults.set(newValue?.rawValue, forKey: .memoSort)
        }
    }

    public var searchAPIKey: String? {
        get {
            userDefaults.string(forKey: .searchAPIKey)
        }
        set {
            userDefaults.set(newValue, forKey: .searchAPIKey)
        }
    }
}

private extension UserDefaultsDataSourceImpl {
    enum Key: String {
        case launchedAppBefore = "launched_app_before"
        case didConfirmReadingBookDescription = "did_confirm_reading_book_description"
        case readBook = "read_book"
        case readingBook = "reading_book"
        case readingBookMemoDrafts = "reading_book_memo_drafts"
        case reviewedVersion = "reviewed_version"
        case bookSort = "current_book_sort"
        case memoSort = "current_memo_sort"
        case searchAPIKey = "search_api_key"
    }
}

private extension UserDefaults {
    func bool(forKey key: UserDefaultsDataSourceImpl.Key) -> Bool {
        bool(forKey: key.rawValue)
    }
    
    func integer(forKey key: UserDefaultsDataSourceImpl.Key) -> Int {
        integer(forKey: key.rawValue)
    }
    
    func string(forKey key: UserDefaultsDataSourceImpl.Key) -> String? {
        string(forKey: key.rawValue)
    }

    func array<T>(forKey key: UserDefaultsDataSourceImpl.Key) -> [T] {
        array(forKey: key.rawValue) as? [T] ?? []
    }

    func dictionary(forKey key: UserDefaultsDataSourceImpl.Key) -> [String: Any] {
        dictionary(forKey: key.rawValue) ?? [:]
    }
    
    func decodableObject<T: Decodable>(forKey key: UserDefaultsDataSourceImpl.Key) -> T? {
        guard let data = data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func set(_ value: Bool, forKey key: UserDefaultsDataSourceImpl.Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set(_ value: Int, forKey key: UserDefaultsDataSourceImpl.Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set(_ value: String?, forKey key: UserDefaultsDataSourceImpl.Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set(_ value: [Any], forKey key: UserDefaultsDataSourceImpl.Key) {
        set(value, forKey: key.rawValue)
    }

    func set(_ value: [String: Any], forKey key: UserDefaultsDataSourceImpl.Key) {
        set(value, forKey: key.rawValue)
    }
    
    func setEncodable<T: Encodable>(_ object: T?, forKey key: UserDefaultsDataSourceImpl.Key) {
        guard let object = object else {
            set(nil, forKey: key)
            return
        }
        let data = try? JSONEncoder().encode(object)
        set(data, forKey: key.rawValue)
    }
}
