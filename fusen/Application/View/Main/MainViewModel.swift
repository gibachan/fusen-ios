//
//  MainViewModel.swift
//  MainViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import Foundation

final class MainViewModel: ObservableObject {
    @Published var showTutorial = false
    @Published var isMaintaining = false
    
    private let accountService: AccountServiceProtocol
    private let appConfigRepository: AppConfigRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        appConfigRepository: AppConfigRepository = AppConfigRepositoryImpl()
    ) {
        self.accountService = accountService
        self.appConfigRepository = appConfigRepository
    }
    
    func onAppear() async {
        log.d("logged in user=\(accountService.currentUser?.id.value ?? "nil")")
        showTutorial = !accountService.isLoggedIn

        let config = await appConfigRepository.get()
        self.isMaintaining = config.isMaintaining
    }
}
