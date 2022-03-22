//
//  AppConfig.swift
//  AppConfig
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import Foundation

struct AppConfig {
    let isMaintaining: Bool
    let isVisionAPIUse: Bool
}

extension AppConfig {
    static var `default`: AppConfig {
        AppConfig(isMaintaining: false, isVisionAPIUse: false)
    }
}

extension AppConfig: CustomStringConvertible {
    var description: String {
        "AppConfig: isMaintaining=\(isMaintaining), isVisionAPIUse=\(isVisionAPIUse)"
    }
}
