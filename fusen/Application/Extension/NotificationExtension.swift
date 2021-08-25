//
//  NotificationExtension.swift
//  NotificationExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

extension Notification.Name {
    static var refreshHome: Notification.Name {
        Notification.Name("refreshHome")
    }
    static var refreshBookShelf: Notification.Name {
        Notification.Name("refreshBookShelf")
    }
    static var refreshBook: Notification.Name {
        Notification.Name("refreshBook")
    }
}
