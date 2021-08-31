//
//  Maintenance.swift
//  Maintenance
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import Foundation

struct Maintenance {
    let isMaintaining: Bool
}

extension Maintenance {
    static var `default`: Maintenance {
        Maintenance(isMaintaining: false)
    }
}
