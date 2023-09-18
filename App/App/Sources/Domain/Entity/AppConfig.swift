//
//  AppConfig.swift
//  AppConfig
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import Foundation

public struct AppConfig {
    public let isMaintaining: Bool

    public init(isMaintaining: Bool) {
        self.isMaintaining = isMaintaining
    }
}

public extension AppConfig {
    static var `default`: AppConfig {
        AppConfig(isMaintaining: false)
    }
}

extension AppConfig: CustomStringConvertible {
    public var description: String {
        "AppConfig: isMaintaining=\(isMaintaining)"
    }
}
