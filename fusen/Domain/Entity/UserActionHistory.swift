//
//  UserActionHistory.swift
//  UserActionHistory
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

struct UserActionHistory {
    let didConfirmReadingBookDescription: Bool
    let readBook: [ID<Book>: Int]
}

extension UserActionHistory {
    static var `default`: UserActionHistory {
        UserActionHistory(didConfirmReadingBookDescription: false, readBook: [:])
    }
}
