//
//  FirestoreGetUserInfo.swift
//  FirestoreGetUserInfo
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import FirebaseFirestore
import Foundation

struct FirestoreGetUserInfo: Codable {
    let readingBookId: String?
}

extension FirestoreGetUserInfo {
    static func from(data: [String: Any]?) -> Self? {
        guard let data = data else { return nil }
        let readingBookId = data["readingBookId"] as? String
        return FirestoreGetUserInfo(readingBookId: readingBookId)
    }
    
    func toDomain() -> UserInfo {
        if let readingBookId = readingBookId, !readingBookId.isEmpty {
            return UserInfo(
                readingBookId: ID<Book>(value: readingBookId)
            )
        } else {
            return UserInfo(
                readingBookId: nil
            )
        }
    }
}
