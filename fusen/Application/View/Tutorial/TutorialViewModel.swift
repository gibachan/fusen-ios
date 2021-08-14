//
//  TutorialViewModel.swift
//  TutorialViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

final class TutorialViewModel: ObservableObject {
    @Published var state: State = .initial

    private let accountService: AccountServiceProtocol
    
    init(accountService: AccountServiceProtocol = AccountService.shared) {
        self.accountService = accountService
    }

    func onClose() async {
        state = .loading
        do {
            await try accountService.logInAnonymously()
            state = .succeeded
        } catch {
            state = .failed
        }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case failed
    }
}
