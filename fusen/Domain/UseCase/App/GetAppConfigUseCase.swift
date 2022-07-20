//
//  GetAppConfigUseCase.swift
//  GetAppConfigUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

protocol GetAppConfigUseCase {
    func invoke() async -> AppConfig
}

final class GetAppConfigUseCaseImpl: GetAppConfigUseCase {
    private let appConfigRepository: AppConfigRepository
    
    init(
        appConfigRepository: AppConfigRepository = AppConfigRepositoryImpl()
    ) {
        self.appConfigRepository = appConfigRepository
    }
    
    func invoke() async -> AppConfig {
        await appConfigRepository.get()
    }
}
