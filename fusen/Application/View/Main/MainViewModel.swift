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
    private let maintenanceRepository: MaintenanceRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        maintenanceRepository: MaintenanceRepository = MaintenanceRepositoryImpl()
    ) {
        self.accountService = accountService
        self.maintenanceRepository = maintenanceRepository
    }
    
    func onAppear() async {
        log.d("logged in user=\(accountService.currentUser?.id.value ?? "nil")")
        showTutorial = !accountService.isLoggedIn

        do {
            let maintenance = try await maintenanceRepository.get()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isMaintaining = maintenance.isMaintaining
            }
        } catch {
            log.e("failed to get maintenance: \(error.localizedDescription)")
        }
    }
}
