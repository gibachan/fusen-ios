//
//  UserInfo.swift
//  UserInfo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Foundation

public struct UserInfo {
    public let readingBookId: ID<Book>?

    public init(readingBookId: ID<Book>? = nil) {
        self.readingBookId = readingBookId
    }
}

public extension UserInfo {
    static var none: UserInfo {
        UserInfo(readingBookId: nil)
    }
}
