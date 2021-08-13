//
//  AppEnv.swift
//  AppEnv
//
//  Created by Tatsuyuki Kobayashi on 2021/08/13.
//

import Foundation

enum AppEnv {
    case development
    case staging
    case production
    
    static var current: AppEnv {
        #if RELEASE
        return .production
        #elseif STAGING
        return .staging
        #else
        return .development
        #endif
    }
}
