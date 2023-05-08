//
//  ErrorHUD.swift
//  ErrorHUD
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import Foundation

final class ErrorHUD {
    static func show(message: ErrorMessage) {
        log.d("LoadingHUD.show(message: \(message.string)")
    }
    
    static func dismiss() {
        log.d("LoadingHUD.dismiss()")
    }
}
