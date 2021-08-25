//
//  SettingTabViewModel.swift
//  SettingTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation
import AuthenticationServices

final class SettingTabViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol

    @Published var state: State = .initial
    @Published var userId: String = ""
    @Published var version: String = ""
    
    init(accountService: AccountServiceProtocol = AccountService.shared) {
        self.accountService = accountService
    }
    
    func onApper() {
        userId = accountService.currentUser?.id.value ?? ""
        version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    func onSignInWithAppleRequest(_ resutst: ASAuthorizationAppleIDRequest) {
        accountService.prepareLogInWithAppleRequest(request: resutst)
    }
    
    func onSignInWithAppleCompletion(_ completion: Result<ASAuthorization, Error>) {
        switch completion {
        case .success(let authorization):
            Task {
                do {
                    try await accountService.linkWithApple(authorization: authorization)
                    log.d("Successfully linked with Apple: user=\(accountService.currentUser?.id ?? "")")
                    DispatchQueue.main.async { [weak self] in
                        self?.state = .succeeded
                    }
                } catch AccountServiceError.linkWithApple {
                    // すでにlinkされている場合はエラーとなる(This credential is already associated with a different user account.)
                    log.e("AccountServiceError.linkWithApple")
                    DispatchQueue.main.async { [weak self] in
                        self?.state = .failed
                    }

                } catch {
                    log.e("Unknown error: \(error.localizedDescription)")
                    DispatchQueue.main.async { [weak self] in
                        self?.state = .failed
                    }

                }
            }
        case .failure(let error):
            // Do nothing
            log.e(error.localizedDescription)
        }
    }
    
    enum State {
        case initial
        case linkingWithApple
        case succeeded
        case failed
        
        var isInProgress: Bool {
            if case .linkingWithApple = self {
                return true
            } else {
                return false
            }
        }
    }
    
#if DEBUG
    func logOut() {
        do {
            try accountService.logOut()
            fatalError("logged out")
        } catch {
            log.e(error.localizedDescription)
        }
    }
#endif
    
}
