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
    private let getUserActionHistoryUseCase: GetUserActionHistoryUseCase
    private let launchAppUseCase: LaunchAppUseCase
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        getAppConfigUseCase: GetAppConfigUseCase = GetAppConfigUseCaseImpl(),
        getUserActionHistoryUseCase: GetUserActionHistoryUseCase = GetUserActionHistoryUseCaseImpl(),
        launchAppUseCase: LaunchAppUseCase = LaunchAppUseCaseImpl()
    ) {
        self.accountService = accountService
        self.getAppConfigUseCase = getAppConfigUseCase
        self.getUserActionHistoryUseCase = getUserActionHistoryUseCase
        self.launchAppUseCase = launchAppUseCase
    }
    
    @MainActor
    func onAppear() async {
        log.d("logged in user=\(accountService.currentUser?.id.value ?? "nil")")
        
        await logoutIfNeed()
        await launchAppUseCase.invoke()

        let config = await getAppConfigUseCase.invoke()
        self.isMaintaining = config.isMaintaining
        if !config.isMaintaining {
            showTutorial = !accountService.isLoggedIn
        }
    }
    
    private func logoutIfNeed() async {
        let history = await getUserActionHistoryUseCase.invoke()
        if !history.launchedAppBefore {
            try? accountService.logOut()
        }
    }
}
