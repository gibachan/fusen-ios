//
//  ID.swift
//  ID
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

// swiftlint:disable:next type_name
public struct ID<T>: Hashable {
    public let value: String
}

extension ID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.value = value
    }
}

extension ID: CustomStringConvertible {
    public var description: String { value }
}

extension ID: Codable {}
