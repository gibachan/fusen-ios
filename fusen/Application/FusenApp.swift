//
//  FusenApp.swift
//  Fusen
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI
import UIKit

@main
struct FusenApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear { setupAppearance() }
        }
    }
}

extension FusenApp {
    private func setupAppearance() {
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.textPrimary
        ]
        UINavigationBar.appearance().tintColor = .active
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        UINavigationBar.appearance().backgroundColor = .clear
        
        UITabBar.appearance().backgroundColor = .backgroundLightGray
    }
}
