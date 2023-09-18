//
//  User.swift
//  User
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

public struct User {
    public let id: ID<User>
    public let isAnonymous: Bool
    public let isLinkedWithAppleId: Bool
    public let isLinkedWithGoogle: Bool

    public init(
        id: ID<User>,
        isAnonymous: Bool,
        isLinkedWithAppleId: Bool,
        isLinkedWithGoogle: Bool
    ) {
        self.id = id
        self.isAnonymous = isAnonymous
        self.isLinkedWithAppleId = isLinkedWithAppleId
        self.isLinkedWithGoogle = isLinkedWithGoogle
    }
}
