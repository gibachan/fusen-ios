//
//  UserDefaultsDataSource.swift
//  UserDefaultsDataSource
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

final class UserDefaultsDataSource {
    let userDefaults = UserDefaults.standard // FIXME: DI
    
    var didConfirmReadingBookDescription: Bool {
        get {
            userDefaults.bool(forKey: .didConfirmReadingBookDescription)
        }
        set {
            userDefaults.set(newValue, forKey: .didConfirmReadingBookDescription)
        }
    }
}

extension UserDefaultsDataSource {
    enum Key: String {
        case didConfirmReadingBookDescription = "did_confirm_reading_book_description"
    }
}

extension UserDefaults {
    func bool(forKey key: UserDefaultsDataSource.Key) -> Bool {
        bool(forKey: key.rawValue)
    }
    
    func set(_ value: Bool, forKey key: UserDefaultsDataSource.Key) {
        set(value, forKey: key.rawValue)
    }
}
