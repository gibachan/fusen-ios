//
//  NotificationExtension.swift
//  NotificationExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

extension Notification.Name {
    static var homePopToRoot: Notification.Name {
        Notification.Name("homePopToRoot")
    }
    static var bookShelfPopToRoot: Notification.Name {
        Notification.Name("bookShelfPopToRoot")
    }
    static var tutorialFinished: Notification.Name {
        Notification.Name("tutorialFinished")
    }
    static var showReadingBookDescription: Notification.Name {
        Notification.Name("showReadingBookDescription")
    }
    static var refreshBookShelfAllCollection: Notification.Name {
        Notification.Name("refreshBookShelfAllCollection")
    }
    static var logOut: Notification.Name {
        Notification.Name("logOut")
    }
    static var error: Notification.Name {
        Notification.Name("error")
    }
    static var newMemoAddedViaDeepLink: Notification.Name {
        Notification.Name("newMemoAddedViaDeepLink")
    }
}

extension Notification {
    static let errorMessageParam = "error_message"
    
    var errorMessage: ErrorMessage? {
        userInfo?[Notification.errorMessageParam] as? ErrorMessage
    }
}
