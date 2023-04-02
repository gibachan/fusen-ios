//
//  SettingTabViewModel.swift
//  SettingTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import AuthenticationServices
import FirebaseAuth
import Foundation

final class SettingTabViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let resetUserActionHistoryUseCase: ResetUserActionHistoryUseCase

    @Published var state: State = .initial
    @Published var userId: String = ""
    @Published var version: String = ""
    @Published var isLinkedAppleId = false
    @Published var isLinkedWithGoogle = false
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        resetUserActionHistoryUseCase: ResetUserActionHistoryUseCase = ResetUserActionHistoryUseCaseImpl()
    ) {
        self.accountService = accountService
        self.resetUserActionHistoryUseCase = resetUserActionHistoryUseCase
    }
    
    @MainActor
    func onApper() {
        let user = accountService.currentUser
        userId = user?.id.value ?? ""
        isLinkedAppleId = user?.isLinkedWithAppleId ?? false
        isLinkedWithGoogle = user?.isLinkedWithGoogle ?? false
        version = Bundle.main.shortVersion
    }
    
    func onSignInWithAppleRequest(_ resutst: ASAuthorizationAppleIDRequest) {
        accountService.prepareLogInWithAppleRequest(request: resutst)
    }
    
    func onSignInWithAppleCompletion(_ completion: Result<ASAuthorization, Error>) {
        self.state = .linkingWithApple
        switch completion {
        case .success(let authorization):
            Task {
                do {
                    try await accountService.linkWithApple(authorization: authorization)
                    log.d("Successfully linked with Apple: user=\(accountService.currentUser?.id ?? "")")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        state = .succeeded
                        isLinkedAppleId = true
                    }
                } catch AccountServiceError.linkWithApple {
                    // すでにlinkされている場合はエラーとなる(This credential is already associated with a different user account.)
                    log.e("AccountServiceError.linkWithApple")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        state = .failedlinkingWithApple
                    }
                } catch {
                    log.e("Unknown error: \(error.localizedDescription)")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        state = .failedlinkingWithApple
                    }
                }
            }
        case .failure(let error):
            // Do nothing
            log.e(error.localizedDescription)
            // FIXME: Change state depending on error type  
            state = .succeeded
        }
    }
    
    func onSignInWithGoogle(_ result: Result<AuthCredential, GoogleSignInError>) {
        self.state = .linkingWithGoogle
        switch result {
        case .success(let credential):
            Task {
                do {
                    let user = try await accountService.linkWithGoogle(credential: credential)
                    log.d("Successfully linked with Google: user=\(user.id)")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        state = .succeeded
                        isLinkedWithGoogle = true
                    }
                } catch AccountServiceError.linkWithApple {
                    // すでにlinkされている場合はエラーとなる(This credential is already associated with a different user account.)
                    log.e("AccountServiceError.linkWithApple")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        state = .failedlinkingWithGoogle
                    }
                } catch {
                    log.e("Unknown error: \(error.localizedDescription)")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        state = .failedlinkingWithGoogle
                    }
                }
            }
        case .failure(let error):
            // Do nothing
            log.e(error.localizedDescription)
            if case .canceled = error {
                self.state = .succeeded
            } else {
                self.state = .failedlinkingWithGoogle
            }
        }
    }
    
    func onUnlinkWithAppleID() async {
        do {
            try await accountService.unlinkWithApple()
            log.d("Successfully unlinked with AppleID")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                state = .succeeded
                isLinkedAppleId = false
            }
        } catch {
            log.e("Unknown error: \(error.localizedDescription)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                state = .failed
            }
        }
    }
    
    func onUnlinkWithGoogle() async {
        do {
            try await accountService.unlinkWithGoogle() 
            log.d("Successfully unlinked with Google")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                state = .succeeded
                isLinkedWithGoogle = false
            }
        } catch {
            log.e("Unknown error: \(error.localizedDescription)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                state = .failed
            }
        }
    }
    
    func onDeleteAccountFinished() {
        if !accountService.isLoggedIn {
            NotificationCenter.default.postLogOut()
        }
    }
    
    func onAppReview() {
        let urlString = "https://itunes.apple.com/jp/app/id1585547803?mt=8&action=write-review"
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    enum State {
        case initial
        case linkingWithApple
        case linkingWithGoogle
        case succeeded
        case failed
        case failedlinkingWithApple
        case failedlinkingWithGoogle
    }
    
#if DEBUG
    func onResetUserActionHstory() async {
        resetUserActionHistoryUseCase.invoke()
    }
    
    func onLogOut() {
        do {
            try accountService.logOut()
            NotificationCenter.default.postLogOut()
        } catch {
            log.e(error.localizedDescription)
        }
    }
#endif
}
