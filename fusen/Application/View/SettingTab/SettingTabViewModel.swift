//
//  SettingTabViewModel.swift
//  SettingTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

final class SettingTabViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    
    init(accountService: AccountServiceProtocol = AccountService.shared) {
        self.accountService = accountService
    }
    
#if DEBUG
    func logOut() {
        accountService.logOut()
        fatalError("logged out")
    }
#endif
    
}
