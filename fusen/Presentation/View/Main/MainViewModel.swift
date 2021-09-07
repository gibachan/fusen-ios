//
//  MainViewModel.swift
//  MainViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    @Published var showTutorial = false
    @Published var isMaintaining = false
    
    private let accountService: AccountServiceProtocol
    private let getAppConfigUseCase: GetAppConfigUseCase
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        getAppConfigUseCase: GetAppConfigUseCase = GetAppConfigUseCaseImpl()
    ) {
        self.accountService = accountService
        self.getAppConfigUseCase = getAppConfigUseCase
    }
    
    func onAppear() async {
        log.d("logged in user=\(accountService.currentUser?.id.value ?? "nil")")
        showTutorial = !accountService.isLoggedIn

        let config = await getAppConfigUseCase.invoke()
        self.isMaintaining = config.isMaintaining
    }
}
