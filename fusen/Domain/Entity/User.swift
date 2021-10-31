//
//  User.swift
//  User
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import FirebaseAuth
import Foundation

struct User {
    let id: ID<User>
    let isAnonymous: Bool
    let isLinkedWithAppleId: Bool
    let isLinkedWithGoogle: Bool
}

extension User {
    static func from(_ user: FirebaseAuth.User) -> User {
        User(
            id: ID<User>(value: user.uid),
            isAnonymous: user.isAnonymous,
            isLinkedWithAppleId: user.isLinkedWithAppleId,
            isLinkedWithGoogle: user.isLinkedWithGoogle
        )
    }
}
