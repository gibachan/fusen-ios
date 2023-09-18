//
//  UserActionHistory.swift
//  UserActionHistory
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

public struct UserActionHistory {
    public let launchedAppBefore: Bool
    public let didConfirmReadingBookDescription: Bool
    public let readBookPages: [ID<Book>: Int]
    public let reviewedVersion: String?
    public let currentBookSort: BookSort?
    public let currentMemoSort: MemoSort?

    public init(
        launchedAppBefore: Bool,
        didConfirmReadingBookDescription: Bool,
        readBookPages: [ID<Book>: Int],
        reviewedVersion: String? = nil,
        currentBookSort: BookSort? = nil,
        currentMemoSort: MemoSort? = nil
    ) {
        self.launchedAppBefore = launchedAppBefore
        self.didConfirmReadingBookDescription = didConfirmReadingBookDescription
        self.readBookPages = readBookPages
        self.reviewedVersion = reviewedVersion
        self.currentBookSort = currentBookSort
        self.currentMemoSort = currentMemoSort
    }
}

public extension UserActionHistory {
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
