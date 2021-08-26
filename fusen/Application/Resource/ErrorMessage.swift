//
//  ErrorMessage.swift
//  ErrorMessage
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import Foundation

enum ErrorMessage {
    case network
    case unexpected
}

extension ErrorMessage {
    var string: String {
        switch self {
        case .network:
            return "データを取得できませんでした。\nネットワーク環境を確認してみてください。"
        case .unexpected:
            return "予期しない問題が発生しました。"
        }
    }
}
