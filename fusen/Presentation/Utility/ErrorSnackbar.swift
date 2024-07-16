//
//  ErrorSnackbar.swift
//  ErrorSnackbar
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import Foundation

final class ErrorSnackbar {
    static func show(message: ErrorMessage) {
        NotificationCenter.default.postError(message: message)
    }
}
