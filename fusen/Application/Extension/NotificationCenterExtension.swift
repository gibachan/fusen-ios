//
//  NotificationCenterExtension.swift
//  NotificationCenterExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

extension NotificationCenter {
    func postRefreshHome() {
        post(name: Notification.Name.refreshHome, object: nil)
    }
    func postRefreshBookShelf() {
        post(name: Notification.Name.refreshBookShelf, object: nil)
    }
    func postRefreshBook() {
        post(name: Notification.Name.refreshBook, object: nil)
    }

    func refreshHomePublisher() -> Publisher {
        publisher(for: Notification.Name.refreshHome)
    }
    func refreshBookShelfPublisher() -> Publisher {
        publisher(for: Notification.Name.refreshBookShelf)
    }
    func refreshBookPublisher() -> Publisher {
        publisher(for: Notification.Name.refreshBook)
    }
}
