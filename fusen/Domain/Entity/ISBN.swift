//
//  ISBN.swift
//  ISBN
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Foundation

enum ISBN {
    case iSBN10(value: String)
    case iSBN13(value: String)

    var value: String {
        switch self {
        case .iSBN10(value: let value): return value
        case .iSBN13(value: let value): return value
        }
    }
}
