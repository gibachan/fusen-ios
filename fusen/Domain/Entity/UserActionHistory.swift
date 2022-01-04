//
//  UserActionHistory.swift
//  UserActionHistory
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

struct UserActionHistory {
    let didConfirmReadingBookDescription: Bool
    let readBookPages: [ID<Book>: Int]
    let reviewedVersion: String?
}

extension UserActionHistory {
    static var `default`: UserActionHistory {
        UserActionHistory(didConfirmReadingBookDescription: false, readBookPages: [:], reviewedVersion: nil)
    }
}
