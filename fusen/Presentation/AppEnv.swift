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
        #if DEVELOPMENT
        return .development
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }
    
    var memoURLScheme: URL {
        switch self {
        case .development:
            return URL(string: "fusen-dev://memo")!
        case .staging:
            return URL(string: "fusen-stg://memo")!
        case .production:
            return URL(string: "fusen://memo")!
        }
    }
}
