//
//  TutorialViewModel.swift
//  TutorialViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation
import AuthenticationServices

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
                        self?.state = .succeeded
                    }
                } catch AccountServiceError.logInApple {
                    log.e("AccountServiceError.logInApple")
                    DispatchQueue.main.async { [weak self] in
                        self?.state = .succeeded
                    }
                } catch {
                    log.e("Unknown error: \(error.localizedDescription)")
                    DispatchQueue.main.async { [weak self] in
                        self?.state = .succeeded
                    }
                }
            }
        case .failure(let error):
            // Do nothing
            log.e(error.localizedDescription)
        }
    }

    func onSkip() async {
        state = .loading
        do {
            try await accountService.logInAnonymously()
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                NotificationCenter.default.postError(message: .unexpected)
                self?.state = .failed
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case failed
    }
}
