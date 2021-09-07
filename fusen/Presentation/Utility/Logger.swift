//
//  Logger.swift
//  Logger
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

final class Logger {
    func d(_ message: String) {
        #if DEBUG
        print("# \(message)")
        #endif
    }
    
    func e(_ message: String) {
        #if DEBUG
        print("# ❌ \(message)")
        #endif
    }
}

let log = Logger()
