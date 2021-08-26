//
//  ID.swift
//  ID
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

// swiftlint:disable:next type_name
struct ID<T>: Hashable {
    let value: String
}

extension ID: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.value = value
    }
}

extension ID: CustomStringConvertible {
    var description: String { value }
}

extension ID: Codable where T: Codable {}
