//
//  NotificationExtension.swift
//  NotificationExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

extension Notification.Name {
    static var tutorialFinished: Notification.Name {
        Notification.Name("tutorialFinished")
    }
    static var refreshBookShelfAllCollection: Notification.Name {
        Notification.Name("refreshBookShelfAllCollection")
    }
    static var error: Notification.Name {
        Notification.Name("error")
    }
}

extension Notification {
    static let errorMessageParam = "error_message"
    
    var errorMessage: ErrorMessage? {
        userInfo?[Notification.errorMessageParam] as? ErrorMessage
    }
}
