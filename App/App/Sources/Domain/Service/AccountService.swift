//
//  AccountService.swift
//  AccountService
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import AuthenticationServices
import FirebaseAuth

public enum AccountServiceError: Error {
    case logInAnonymously
    case logInApple
    case linkWithApple
    case linkWithGoogle
    case logInWithGoogle
    case logOut
    case unlinkWithApple
    case unlinkWithGoogle
    case deleteAccount
    case reAuthenticate
    case notAuthenticated
}

public protocol AccountServiceProtocol {
    var isLoggedIn: Bool { get }
    var currentUser: User? { get }
    @discardableResult func logInAnonymously() async throws -> User
    
    func prepareLogInWithAppleRequest(request: ASAuthorizationAppleIDRequest)
    @discardableResult func logInWithApple(authorization: ASAuthorization) async throws -> User
    @discardableResult func linkWithApple(authorization: ASAuthorization) async throws -> User
    func unlinkWithApple() async throws
    func reAuthenticateWithApple(authorization: ASAuthorization) async throws
    func logInWithGoogle(credential: AuthCredential) async throws -> User
    func linkWithGoogle(credential: AuthCredential) async throws -> User
    func unlinkWithGoogle() async throws
    func reAuthenticateWithGoogle(credential: AuthCredential) async throws
    func delete() async throws
    func logOut() throws
}
