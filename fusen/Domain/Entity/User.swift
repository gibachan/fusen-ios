//
//  User.swift
//  User
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

struct User {
    let id: ID<User>
    let isAnonymous: Bool
    let isLinkedWithAppleId: Bool
}
