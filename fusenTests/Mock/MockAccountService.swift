//
//  MockAccountService.swift
//  MockAccountService
//
//  Created by Tatsuyuki Kobayashi on 2021/09/08.
//

import Foundation
import AuthenticationServices
@testable import fusen

final class MockAccountService: AccountServiceProtocol {
    init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
    
    var isLoggedIn: Bool
    
    var currentUser: User? {
        if isLoggedIn {
            return User.test
        } else {
            return nil
        }
    }
    
    func logInAnonymously() async throws -> User {
        fatalError()
    }
    
    func prepareLogInWithAppleRequest(request: ASAuthorizationAppleIDRequest) {
        fatalError()
    }
    
    func logInWithApple(authorization: ASAuthorization) async throws -> User {
        fatalError()
    }
    
    func linkWithApple(authorization: ASAuthorization) async throws -> User {
        fatalError()
    }
    
    func unlinkWithApple() async throws {
        fatalError()
    }
    
    func delete() async throws {
        fatalError()
    }
    
    func logOut() throws {
        fatalError()
    }
}

extension User {
    static var test: User {
        User(id: ID<User>(value: "123"), isAnonymous: true, isLinkedWithAppleId: false)
    }
}
