//
//  FirebaseAuthExtension.swift
//  FirebaseAuthExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/09/02.
//

import FirebaseAuth

let appleProviderId = "apple.com"
let googleProviderId = "google.com"

extension FirebaseAuth.User {
    var isLinkedWithAppleId: Bool {
        providerData.contains(where: { $0.providerID == appleProviderId })
    }
    var isLinkedWithGoogle: Bool {
        providerData.contains(where: { $0.providerID == googleProviderId })
    }
    var user: User {
        User(
            id: ID<User>(value: uid),
            isAnonymous: isAnonymous,
            isLinkedWithAppleId: isLinkedWithAppleId,
            isLinkedWithGoogle: isLinkedWithGoogle
        )
    }
}
