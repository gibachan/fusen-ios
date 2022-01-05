//
//  UserDefaultsDataSource.swift
//  UserDefaultsDataSource
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

final class UserDefaultsDataSource {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var didConfirmReadingBookDescription: Bool {
        get {
            userDefaults.bool(forKey: .didConfirmReadingBookDescription)
        }
        set {
            userDefaults.set(newValue, forKey: .didConfirmReadingBookDescription)
        }
    }
    
    var readBookPages: [String: Any] {
        userDefaults.dictionary(forKey: .readBook)
    }
    
    func getReadPage(for book: Book) -> Int? {
        let readBook = userDefaults.dictionary(forKey: .readBook)
        return readBook[book.id.value] as? Int
    }
    
    func setReadPage(for book: Book, page: Int) {
        var readBook = userDefaults.dictionary(forKey: .readBook)
        readBook[book.id.value] = page
        userDefaults.set(readBook, forKey: .readBook)
    }
    
    var reviewedVersion: String? {
        get {
            userDefaults.string(forKey: .reviewedVersion)
        }
        set {
            userDefaults.set(newValue, forKey: .reviewedVersion)
        }
    }
}

extension UserDefaultsDataSource {
    enum Key: String {
        case didConfirmReadingBookDescription = "did_confirm_reading_book_description"
        case readBook = "read_book"
        case reviewedVersion = "reviewed_version"
    }
}

extension UserDefaults {
    func bool(forKey key: UserDefaultsDataSource.Key) -> Bool {
        bool(forKey: key.rawValue)
    }
    
    func integer(forKey key: UserDefaultsDataSource.Key) -> Int {
        integer(forKey: key.rawValue)
    }
    
    func string(forKey key: UserDefaultsDataSource.Key) -> String? {
        string(forKey: key.rawValue)
    }

    func dictionary(forKey key: UserDefaultsDataSource.Key) -> [String: Any] {
        dictionary(forKey: key.rawValue) ?? [:]
    }

    func set(_ value: Bool, forKey key: UserDefaultsDataSource.Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set(_ value: Int, forKey key: UserDefaultsDataSource.Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set(_ value: String?, forKey key: UserDefaultsDataSource.Key) {
        set(value, forKey: key.rawValue)
    }
    
    func set(_ value: [String: Any], forKey key: UserDefaultsDataSource.Key) {
        set(value, forKey: key.rawValue)
    }
}
