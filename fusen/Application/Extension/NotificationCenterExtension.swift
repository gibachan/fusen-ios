//
//  NotificationCenterExtension.swift
//  NotificationCenterExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

extension NotificationCenter {
    func postError(message: ErrorMessage) {
        post(name: Notification.Name.error, object: nil, userInfo: [Notification.errorMessageParam: message])
    }
    func postRefreshBookShelfAllCollection() {
        post(name: Notification.Name.refreshBookShelfAllCollection, object: nil)
    }

    func errorPublisher() -> Publisher {
        publisher(for: Notification.Name.error)
    }
    func refreshBookShelfAllCollectionPublisher() -> Publisher {
        publisher(for: Notification.Name.refreshBookShelfAllCollection)
    }
}
