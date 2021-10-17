//
//  FirebaseAuthExtension.swift
//  FirebaseAuthExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/09/02.
//

import FirebaseAuth

extension FirebaseAuth.User {
    var isLinkedWithAppleId: Bool {
        let appleProviderId = "apple.com"
        return providerData.contains(where: { $0.providerID == appleProviderId })
    }
    var isLinkedWithGoogle: Bool {
        let providerId = "google.com"
        return providerData.contains(where: { $0.providerID == providerId })
    }
}
