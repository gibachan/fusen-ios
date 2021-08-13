//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by Tatsuyuki Kobayashi on 2021/08/13.
//

import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupFirebase()
        return true
    }
    
    private func setupFirebase() {
        // ref: https://stackoverflow.com/questions/62626652/where-to-configure-firebase-in-my-ios-app-in-the-new-swiftui-app-life-cycle-with
        switch AppEnv.current {
        case .development:
            let filePath = Bundle.main.path(forResource: "GoogleService-Info-development", ofType: "plist")
            let options = FirebaseOptions(contentsOfFile: filePath!)!
            FirebaseApp.configure(options: options)
        case .staging:
            let filePath = Bundle.main.path(forResource: "GoogleService-Info-staging", ofType: "plist")
            let options = FirebaseOptions(contentsOfFile: filePath!)!
            FirebaseApp.configure(options: options)
        case .production:
            // TODO: Set up for production release
            FirebaseApp.configure()
        }
    }
}
