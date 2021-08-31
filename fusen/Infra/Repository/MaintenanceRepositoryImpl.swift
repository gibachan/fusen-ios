//
//  MaintenanceRepositoryImpl.swift
//  MaintenanceRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import Foundation
import FirebaseRemoteConfig

final class MaintenanceRepositoryImpl: MaintenanceRepository {
    private static let maintenanceKey = "maintenance"

    private static let remoteConfig: RemoteConfig = {
        let config = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #else
        settings.minimumFetchInterval = 1 * 60 * 60 // 1 houer
        #endif
        config.configSettings = settings
        config.setDefaults([
            maintenanceKey: false as NSObject
        ])
        return config
    }()
    
    func get() async throws -> Maintenance {
        do {
            let result = try await Self.remoteConfig.fetch()
            if case .success = result {
                let changed = try await Self.remoteConfig.activate()
                if changed {
                    let maintenanceValue = Self.remoteConfig.configValue(forKey: Self.maintenanceKey)
                    return Maintenance(isMaintaining: maintenanceValue.boolValue)
                }
            }
            return .default
        } catch {
            log.d(error.localizedDescription)
            return .default
        }
    }
}
