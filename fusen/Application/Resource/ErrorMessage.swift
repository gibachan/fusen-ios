//
//  ErrorMessage.swift
//  ErrorMessage
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import Foundation

enum ErrorMessage {
    case network
    case readingBookChange
    case favoriteBookChange
    case addCollection
    case selectCollection
    case deleteCollection
    case scanBarcode
    case addBook
    case editBook
    case deleteBook
    case getMemo
    case addMemo
    case editMemo
    case deleteMemo
    case unexpected
}

extension ErrorMessage {
    var string: String {
        switch self {
        case .network:
            return "データを取得できませんでした。\nネットワーク環境を確認してみてください。"
        case .readingBookChange:
            return "読書中の設定を変更できませんでした。"
        case .favoriteBookChange:
            return "お気に入りの設定を変更できませんでした。"
        case .addCollection:
            return "コレクションを追加できませんでした。"
        case .selectCollection:
            return "コレクションを設定できませんでした。"
        case .deleteCollection:
            return "コレクションを削除できませんでした。"
        case .scanBarcode:
            return "バーコードから書籍情報を取得できませんでした。"
        case .addBook:
            return "書籍を追加できませんでした。"
        case .editBook:
            return "書籍を編集できませんでした。"
        case .deleteBook:
            return "書籍を削除できませんでした。"
        case .getMemo:
            return "メモを取得できませんでした。\nネットワーク環境を確認してみてください。"
        case .addMemo:
            return "メモを追加できませんでした。"
        case .editMemo:
            return "メモを編集できませんでした。"
        case .deleteMemo:
            return "メモを削除できませんでした。"
        case .unexpected:
            return "予期しない問題が発生しました。"
        }
    }
}
