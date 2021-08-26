//
//  NotificationCenterExtension.swift
//  NotificationCenterExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

extension NotificationCenter {
    func postRefreshBookShelfAllCollection() {
        post(name: Notification.Name.refreshBookShelfAllCollection, object: nil)
    }

    func refreshBookShelfAllCollectionPublisher() -> Publisher {
        publisher(for: Notification.Name.refreshBookShelfAllCollection)
    }
}
