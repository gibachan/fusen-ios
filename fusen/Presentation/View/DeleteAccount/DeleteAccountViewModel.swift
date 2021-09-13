//
//  DeleteAccountViewModel.swift
//  DeleteAccountViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/09/10.
//

import AuthenticationServices
import Foundation

final class DeleteAccountViewModel: ObservableObject {
    @Published var state: State = .initial
    @Published var isLinkedWithAppleId = false
    
    private let accountService: AccountServiceProtocol
    
    init(accountService: AccountServiceProtocol = AccountService.shared) {
        self.accountService = accountService
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else {
            return
        }
        
        isLinkedWithAppleId = user.isLinkedWithAppleId
    }
    
    func onSignInWithAppleRequest(_ resutst: ASAuthorizationAppleIDRequest) {
        accountService.prepareLogInWithAppleRequest(request: resutst)
    }
    
    func onSignInWithAppleCompletion(_ completion: Result<ASAuthorization, Error>) {
        switch completion {
        case .success(let authorization):
            self.state = .loading
            Task {
                do {
                    try await accountService.reAuthenticateWithApple(authorization: authorization)
                    try await accountService.delete()
                    log.d("Successfully deleted account")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.state = .deleted
                    }
                } catch {
                    log.e("Unknown error: \(error.localizedDescription)")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.state = .failed
                    }
                }
            }
        case .failure(let error):
            // Do nothing
            log.e(error.localizedDescription)
        }
    }
    
    func onDeleteAccount() async {
        guard !state.isInProgress else { return }
        guard let user = accountService.currentUser else {
            return
        }
        guard !user.isLinkedWithAppleId else {
            log.e("Should unlink with Apple ID first")
            return
        }
        
        state = .loading
        do {
            try await accountService.delete()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .deleted
            }
        } catch {
            log.e("Failed to delete account: \(error.localizedDescription)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case deleted
        case failed
        
        var isInProgress: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }
}
