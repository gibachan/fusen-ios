//
//  UserInfo.swift
//  UserInfo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Foundation

struct UserInfo {
    let readingBookId: ID<Book>?
}

extension UserInfo {
    static var none: UserInfo {
        UserInfo(readingBookId: nil)
    }
}
