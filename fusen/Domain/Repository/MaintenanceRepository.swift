//
//  MaintenanceRepository.swift
//  MaintenanceRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import Foundation

enum MaintenanceRepositoryError: Error {
    case get
}

protocol MaintenanceRepository {
    func get() async throws -> Maintenance
}
