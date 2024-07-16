//
//  MainViewModel.swift
//  MainViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import Data
import Domain
import Foundation

final class MainViewModel: ObservableObject {
    @Published var showTutorial = false
    @Published var isMaintaining = false
    
    private let accountService: AccountServiceProtocol
    private let getAppConfigUseCase: GetAppConfigUseCase
    private let getUserActionHistoryUseCase: GetUserActionHistoryUseCase
    private let launchAppUseCase: LaunchAppUseCase
    private let addDraftMemoUseCase: AddDraftMemoUseCase
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        getAppConfigUseCase: GetAppConfigUseCase = GetAppConfigUseCaseImpl(appConfigRepository: AppConfigRepositoryImpl()),
        getUserActionHistoryUseCase: GetUserActionHistoryUseCase = GetUserActionHistoryUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl()),
        launchAppUseCase: LaunchAppUseCase = LaunchAppUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl()),
        addDraftMemoUseCase: AddDraftMemoUseCase = AddDraftMemoUseCaseImpl(accountService: AccountService.shared, memoRepository: MemoRepositoryImpl())
    ) {
        self.accountService = accountService
        self.getAppConfigUseCase = getAppConfigUseCase
        self.getUserActionHistoryUseCase = getUserActionHistoryUseCase
        self.launchAppUseCase = launchAppUseCase
        self.addDraftMemoUseCase = addDraftMemoUseCase
    }
    
    @MainActor
    func onAppear() async {
        log.d("logged in user=\(accountService.currentUser?.id.value ?? "nil")")
        
        await logoutIfNeed()
        launchAppUseCase.invoke()

        let config = await getAppConfigUseCase.invoke()
        self.isMaintaining = config.isMaintaining
        if !config.isMaintaining {
            showTutorial = !accountService.isLoggedIn
        }
    }
    
    @MainActor
    func onDeepLink(url: URL) async {
        guard url == AppEnv.current.memoURLScheme else { return }
        
        do {
            _ = try await addDraftMemoUseCase.invoke()
            NotificationCenter.default.postNewMemoAddedViaDeepLink()
        } catch {
            log.e(error.localizedDescription)
        }
    }
    
    private func logoutIfNeed() async {
        let history = getUserActionHistoryUseCase.invoke()
        if !history.launchedAppBefore {
            try? accountService.logOut()
        }
    }
}
