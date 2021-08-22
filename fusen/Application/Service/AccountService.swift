//
//  AccountService.swift
//  AccountService
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation
import FirebaseAuth

enum AccountServiceError: Error {
    case failedToLogInAnonymously
}

protocol AccountServiceProtocol {
    var isLoggedIn: Bool { get }
    var currentUser: User? { get }
    @discardableResult func logInAnonymously() async throws -> User
#if DEBUG
    func logOut()
#endif
}

final class AccountService: AccountServiceProtocol {
    static let shared: AccountServiceProtocol = AccountService()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    var isLoggedIn: Bool {
        auth.currentUser != nil
    }
    
    var currentUser: User? {
        guard let user = auth.currentUser else { return nil }
        return User(id: ID<User>(value: user.uid), isAnonymous: user.isAnonymous)
    }
    
    @discardableResult func logInAnonymously() async throws -> User {
        do {
            let result = try await auth.signInAnonymously()
            let user = result.user
            log.d("logInAnonymously: uid=\(user.uid)")
            return User(id: ID<User>(value: user.uid), isAnonymous: user.isAnonymous)
        } catch {
            log.e(error.localizedDescription)
            throw AccountServiceError.failedToLogInAnonymously
        }
    }
    
    func logOut() {
        do {
            try auth.signOut()
        } catch {
            log.e(error.localizedDescription)
        }
    }
}
