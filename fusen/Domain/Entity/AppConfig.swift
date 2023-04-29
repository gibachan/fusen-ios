//
//  AppConfig.swift
//  AppConfig
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import Foundation

struct AppConfig {
    let isMaintaining: Bool
}

extension AppConfig {
    static var `default`: AppConfig {
        AppConfig(isMaintaining: false)
    }
}

extension AppConfig: CustomStringConvertible {
    var description: String {
        "AppConfig: isMaintaining=\(isMaintaining)"
    }
}
