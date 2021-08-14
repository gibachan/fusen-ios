//
//  MainViewModel.swift
//  MainViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import Foundation

final class MainViewModel: ObservableObject {
    @Published var showTutorial = false
    
    private let accountService: AccountServiceProtocol
    
    init(accountService: AccountServiceProtocol = AccountService.shared) {
        self.accountService = accountService
    }
    
    func onAppear() {
        showTutorial = !accountService.isLoggedIn
    }
}
