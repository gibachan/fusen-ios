//
//  FirestoreGetUserInfo.swift
//  FirestoreGetUserInfo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Domain
import FirebaseFirestore
import Foundation

struct FirestoreGetUserInfo: Codable {
    let readingBookId: String?
}

extension FirestoreGetUserInfo {
    func toDomain() -> UserInfo {
        if let readingBookId = readingBookId, !readingBookId.isEmpty {
            return UserInfo(
                readingBookId: ID<Book>(stringLiteral: readingBookId)
            )
        } else {
            return UserInfo(
                readingBookId: nil
            )
        }
    }
}
