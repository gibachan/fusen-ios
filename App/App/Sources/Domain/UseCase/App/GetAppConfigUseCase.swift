//
//  GetAppConfigUseCase.swift
//  GetAppConfigUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public protocol GetAppConfigUseCase {
    func invoke() async -> AppConfig
}

public final class GetAppConfigUseCaseImpl: GetAppConfigUseCase {
    private let appConfigRepository: AppConfigRepository
    
    public init(
        appConfigRepository: AppConfigRepository
    ) {
        self.appConfigRepository = appConfigRepository
    }
    
    public func invoke() async -> AppConfig {
        await appConfigRepository.get()
    }
}
