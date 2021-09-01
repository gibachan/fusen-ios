//
//  AppConfigRepository.swift
//  AppConfigRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import Foundation

protocol AppConfigRepository {
    func get() async -> AppConfig
}
