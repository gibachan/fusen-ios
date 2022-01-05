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
    private let getAppConfigUseCase: GetAppConfigUseCase
    
    nonisolated init(
        accountService: AccountServiceProtocol = AccountService.shared,
        getAppConfigUseCase: GetAppConfigUseCase = GetAppConfigUseCaseImpl()
    ) {
        self.accountService = accountService
        self.getAppConfigUseCase = getAppConfigUseCase
    }
    
    @MainActor
    func onAppear() async {
        log.d("logged in user=\(accountService.currentUser?.id.value ?? "nil")")

        let config = await getAppConfigUseCase.invoke()
        self.isMaintaining = config.isMaintaining
        if !config.isMaintaining {
            showTutorial = !accountService.isLoggedIn
        }
    }
}
