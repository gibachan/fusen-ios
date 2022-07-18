//
//  UserActionHistory.swift
//  UserActionHistory
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

struct UserActionHistory {
    let launchedAppBefore: Bool
    let didConfirmReadingBookDescription: Bool
    let readBookPages: [ID<Book>: Int]
    let reviewedVersion: String?
    let currentBookSort: BookSort?
    let currentMemoSort: MemoSort?
}

extension UserActionHistory {
    static var `default`: UserActionHistory {
        UserActionHistory(
            launchedAppBefore: false,
            didConfirmReadingBookDescription: false,
            readBookPages: [:],
            reviewedVersion: nil,
            currentBookSort: nil,
            currentMemoSort: nil
        )
    }
}
