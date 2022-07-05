//
//  TutorialViewModel.swift
//  TutorialViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import AuthenticationServices
import FirebaseAuth
import Foundation

final class TutorialViewModel: ObservableObject {
    @Published var state: State = .initial
    
    private let accountService: AccountServiceProtocol
    
    init(accountService: AccountServiceProtocol = AccountService.shared) {
        self.accountService = accountService
    }
    
    func onSignInWithAppleRequest(_ resutst: ASAuthorizationAppleIDRequest) {
        accountService.prepareLogInWithAppleRequest(request: resutst)
    }
    
    func onSignInWithAppleCompletion(_ completion: Result<ASAuthorization, Error>) {
        switch completion {
        case .success(let authorization):
            Task {
                do {
                    try await accountService.logInWithApple(authorization: authorization)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.state = .succeeded
                        NotificationCenter.default.postTutorialFinished()
                    }
                } catch AccountServiceError.logInApple {
                    log.e("AccountServiceError.logInApple")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.state = .failedSigningWithApple
                    }
                } catch {
                    log.e("Unknown error: \(error.localizedDescription)")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.state = .failedSigningWithApple
                    }
                }
            }
        case .failure(let error):
            // Do nothing
            log.e(error.localizedDescription)
        }
    }
    
    func onSignInWithGoogle(_ result: Result<AuthCredential, GoogleSignInError>) {
        self.state = .loading
        switch result {
        case .success(let credential):
            Task {
                do {
                    let user = try await accountService.logInWithGoogle(credential: credential)
                    log.d("Successfully logged in with Google: user=\(user.id)")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.state = .succeeded
                        NotificationCenter.default.postTutorialFinished()
                    }
                } catch AccountServiceError.logInWithGoogle {
                    // すでにlinkされている場合はエラーとなる(This credential is already associated with a different user account.)
                    log.e("AccountServiceError.logInWithGoogle")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.state = .failedSigningWithGoogle
                    }
                } catch {
                    log.e("Unknown error: \(error.localizedDescription)")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.state = .failedSigningWithGoogle
                    }
                }
            }
        case .failure(let error):
            // Do nothing
            log.e(error.localizedDescription)
        }
    }

    @MainActor
    func onSkip() async {
        state = .loading
        do {
            try await accountService.logInAnonymously()
            state = .succeeded
            NotificationCenter.default.postTutorialFinished()
        } catch {
            state = .failed
        }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case failed
        case failedSigningWithApple
        case failedSigningWithGoogle
    }
}
