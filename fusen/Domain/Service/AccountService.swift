//
//  AccountService.swift
//  AccountService
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAnalytics
import FirebaseAuth
import FirebaseCrashlytics
import Foundation
import GoogleSignIn

enum AccountServiceError: Error {
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

protocol AccountServiceProtocol {
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
    func delete() async throws
    func logOut() throws
}

final class AccountService: AccountServiceProtocol {
    static let shared: AccountServiceProtocol = AccountService()
    
    private let auth = Auth.auth()
    
    // Unhashed nonce.
    private var currentNonce: String?
    
    private init() {}
    
    var isLoggedIn: Bool {
        auth.currentUser != nil
    }
    
    var currentUser: User? {
        guard let authUser = auth.currentUser else { return nil }
        return User.from(authUser)
    }
    
    @discardableResult func logInAnonymously() async throws -> User {
        do {
            let result = try await auth.signInAnonymously()
            let authUser = result.user
            log.d("logInAnonymously: uid=\(authUser.uid)")
            let user = User.from(authUser)
            setUserProperty(user: user)
            return user
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.logInAnonymously
        }
    }
    
    func prepareLogInWithAppleRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = []
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    @discardableResult func logInWithApple(authorization: ASAuthorization) async throws -> User {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            log.e("ASAuthorizationAppleIDCredential is not found")
            throw AccountServiceError.logInApple
        }
        guard let nonce = currentNonce else {
            log.e("Should call prepareLogInWithAppleRequest(request:) before logInWithApple(authorization:)")
            throw AccountServiceError.logInApple
        }
        guard let appleIDToken = credential.identityToken else {
            log.e("IDToken is missing")
            throw AccountServiceError.logInApple
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            log.e("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            throw AccountServiceError.logInApple
        }
        
        // Initialize a Firebase credential.
        let providerCredential = OAuthProvider.credential(
            withProviderID: appleProviderId,
            idToken: idTokenString,
            rawNonce: nonce
        )
        // Sign in with Firebase.
        do {
            let result = try await auth.signIn(with: providerCredential)
            let authUser = result.user
            log.d("logInWithApple: uid=\(authUser.uid)")
            currentNonce = nil
            let user = User.from(authUser)
            setUserProperty(user: user)
            return user
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.logInApple
        }
    }
    
    @discardableResult func linkWithApple(authorization: ASAuthorization) async throws -> User {
        guard let authUser = auth.currentUser else {
            log.e("currentUser is missing")
            throw AccountServiceError.notAuthenticated
        }
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            log.e("ASAuthorizationAppleIDCredential is not found")
            throw AccountServiceError.linkWithApple
        }
        guard let nonce = currentNonce else {
            log.e("Should call prepareLogInWithAppleRequest(request:) before logInWithApple(authorization:)")
            throw AccountServiceError.linkWithApple
        }
        guard let appleIDToken = credential.identityToken else {
            log.e("IDToken is missing")
            throw AccountServiceError.linkWithApple
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            log.e("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            throw AccountServiceError.linkWithApple
        }
        
        // Initialize a Firebase credential.
        let providerCredential = OAuthProvider.credential(
            withProviderID: appleProviderId,
            idToken: idTokenString,
            rawNonce: nonce
        )
        // link with Firebase.
        do {
            let result = try await authUser.link(with: providerCredential)
            let linkedAuthUser = result.user
            log.d("linkWithApple: uid=\(linkedAuthUser.uid)")
            currentNonce = nil
            let user = User.from(linkedAuthUser)
            setUserProperty(user: user)
            return user
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.linkWithApple
        }
    }
    
    func unlinkWithApple() async throws {
        do {
            try await auth.currentUser?.unlink(fromProvider: appleProviderId)
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.unlinkWithApple
        }
    }
    
    func reAuthenticateWithApple(authorization: ASAuthorization) async throws {
        guard let authUser = auth.currentUser else {
            log.e("currentUser is missing")
            throw AccountServiceError.notAuthenticated
        }
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            log.e("ASAuthorizationAppleIDCredential is not found")
            throw AccountServiceError.reAuthenticate
        }
        guard let nonce = currentNonce else {
            log.e("Should call prepareLogInWithAppleRequest(request:) before logInWithApple(authorization:)")
            throw AccountServiceError.reAuthenticate
        }
        guard let appleIDToken = credential.identityToken else {
            log.e("IDToken is missing")
            throw AccountServiceError.reAuthenticate
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            log.e("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            throw AccountServiceError.reAuthenticate
        }
        
        // Initialize a Firebase credential.
        let providerCredential = OAuthProvider.credential(
            withProviderID: appleProviderId,
            idToken: idTokenString,
            rawNonce: nonce
        )
        // link with Firebase.
        do {
            try await authUser.reauthenticate(with: providerCredential)
            log.d("Successfully reauthenticated")
            currentNonce = nil
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.reAuthenticate
        }
    }
    
    func logInWithGoogle(credential: AuthCredential) async throws -> User {
        do {
            let result = try await auth.signIn(with: credential)
            let authUser = result.user
            log.d("logInWithGoogle: uid=\(authUser.uid)")
            let user = User.from(authUser)
            setUserProperty(user: user)
            return user
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.logInWithGoogle
        }
    }
    
    @discardableResult func linkWithGoogle(credential: AuthCredential) async throws -> User {
        guard let authUser = auth.currentUser else {
            log.e("currentUser is missing")
            throw AccountServiceError.notAuthenticated
        }

        // link with Firebase.
        do {
            let result = try await authUser.link(with: credential)
            let linkedAuthUser = result.user
            log.d("linkWithGoogle: uid=\(linkedAuthUser.uid)")
            let user = User.from(linkedAuthUser)
            setUserProperty(user: user)
            return user
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.linkWithGoogle
        }
    }
    
    func unlinkWithGoogle() async throws {
        do {
            try await auth.currentUser?.unlink(fromProvider: googleProviderId)
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.unlinkWithGoogle
        }
    }
    
    func delete() async throws {
        guard let user = auth.currentUser else {
            throw AccountServiceError.notAuthenticated
        }
        // 匿名認証以外のユーザー削除の前には再認証が必要 https://firebase.google.com/docs/auth/web/manage-users?hl=ja#re-authenticate_a_user
        do {
            try await user.delete()
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.deleteAccount
        }
    }
    
    func logOut() throws {
        do {
            try auth.signOut()
            resetsetUserProperty()
        } catch let signOutError as NSError {
            log.e("Error signing out: \(signOutError)")
            throw AccountServiceError.logOut
        } catch {
            throw AccountServiceError.logOut
        }
    }
    
    private func setUserProperty(user: User) {
        Analytics.setUserID(user.id.value)
        Analytics.setUserProperty(user.isLinkedWithAppleId ? "true" : "false", forName: "linked_with_apple_id")
        Analytics.setUserProperty(user.isLinkedWithGoogle ? "true" : "false", forName: "linked_with_google")
        Crashlytics.crashlytics().setUserID(user.id.value)
    }
    
    private func resetsetUserProperty() {
        Analytics.setUserID(nil)
        Analytics.setUserProperty(nil, forName: "linked_with_apple_id")
        Analytics.setUserProperty(nil, forName: "linked_with_google")
        Crashlytics.crashlytics().setUserID("")
    }
}

extension AccountService {
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
