//
//  UIApplicationExtensoin.swift
//  UIApplicationExtensoin
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })
    }
    
    var currentRootViewController: UIViewController? {
        currentKeyWindow?.rootViewController
    }
}
