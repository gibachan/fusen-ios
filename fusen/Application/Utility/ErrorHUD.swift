//
//  ErrorHUD.swift
//  ErrorHUD
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import Foundation
import SVProgressHUD

final class ErrorHUD {
    static func show(message: ErrorMessage) {
        SVProgressHUD.showError(withStatus: message.string)
    }
    
    static func dismiss() {
        SVProgressHUD.dismiss()
    }
}
