//
//  AppDelegate.swift
//  AppDelegate
//
//  Created by Tatsuyuki Kobayashi on 2021/08/13.
//

import FirebaseCore
import GoogleSignIn
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupFirebase()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
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
            // GoogleService-Info.plist is set at build phase script
            FirebaseApp.configure()
        }
    }
}
