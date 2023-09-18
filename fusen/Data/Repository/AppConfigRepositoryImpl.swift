//
//  AppConfigRepositoryImpl.swift
//  AppConfigRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import Domain
import FirebaseRemoteConfig
import Foundation

final class AppConfigRepositoryImpl: AppConfigRepository {
    private static let maintenanceKey = "maintenance"

    private static let remoteConfig: RemoteConfig = {
        let config = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #else
        settings.minimumFetchInterval = 1 * 60 * 60 // 1 hour
        #endif
        config.configSettings = settings
        config.setDefaults([
            maintenanceKey: false as NSObject,
        ])
        return config
    }()
    
    func get() async -> AppConfig {
        do {
            let result = try await Self.remoteConfig.fetch()
            if case .success = result {
                try await Self.remoteConfig.activate()
                let maintenanceValue = Self.remoteConfig.configValue(forKey: Self.maintenanceKey)
                return AppConfig(isMaintaining: maintenanceValue.boolValue)
            }
            return .default
        } catch {
            log.d(error.localizedDescription)
            return .default
        }
    }
}
