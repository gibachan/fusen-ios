//
//  LoadingHUD.swift
//  LoadingHUD
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation
import SVProgressHUD

final class LoadingHUD {
    static func show() {
        SVProgressHUD.show()
    }
    
    static func dismiss() {
        SVProgressHUD.dismiss()
    }
}
