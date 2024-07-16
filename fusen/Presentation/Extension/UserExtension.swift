//
//  UserExtension.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/09/18.
//

import Domain
import FirebaseAuth

typealias User = Domain.User

extension User {
    static func from(_ user: FirebaseAuth.User) -> User {
        User(
            id: ID<User>(stringLiteral: user.uid),
            isAnonymous: user.isAnonymous,
            isLinkedWithAppleId: user.isLinkedWithAppleId,
            isLinkedWithGoogle: user.isLinkedWithGoogle
        )
    }
}
