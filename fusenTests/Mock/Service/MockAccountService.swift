//
//  MockAccountService.swift
//  MockAccountService
//
//  Created by Tatsuyuki Kobayashi on 2021/09/08.
//

import AuthenticationServices
import Foundation
@testable import fusen

final class MockAccountService: AccountServiceProtocol {
    var isLoggedInAnonymously = false
    var isLoggedInWithApple = false
    
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
        isLoggedInAnonymously = true
        return User.test
    }
    
    func prepareLogInWithAppleRequest(request: ASAuthorizationAppleIDRequest) {
        fatalError("Not implemented yet")
    }
    
    func logInWithApple(authorization: ASAuthorization) async throws -> User {
        isLoggedInWithApple = true
        return User.test
    }
    
    func linkWithApple(authorization: ASAuthorization) async throws -> User {
        User.test
    }
    
    func reAuthenticateWithApple(authorization: ASAuthorization) async throws {
        fatalError("Not implemented yet")
    }
    
    func unlinkWithApple() async throws {
        fatalError("Not implemented yet")
    }
    
    func delete() async throws {
        fatalError("Not implemented yet")
    }
    
    func logOut() throws {
        fatalError("Not implemented yet")
    }
}

extension User {
    static var test: User {
        User(id: ID<User>(value: "123"), isAnonymous: true, isLinkedWithAppleId: false)
    }
}