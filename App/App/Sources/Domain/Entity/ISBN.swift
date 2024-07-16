//
//  ISBN.swift
//  ISBN
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Foundation

public enum ISBN {
    case iSBN10(value: String)
    case iSBN13(value: String)

    public var value: String {
        switch self {
        case .iSBN10(value: let value): return value
        case .iSBN13(value: let value): return value
        }
    }
    
    public static func from(code: String) -> ISBN? {
        switch code.count {
        case 10: return .iSBN10(value: code)
        case 13: return .iSBN13(value: code)
        default: return nil
        }
    }
}
