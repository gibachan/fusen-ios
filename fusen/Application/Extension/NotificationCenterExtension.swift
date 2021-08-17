//
//  NotificationCenterExtension.swift
//  NotificationCenterExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

extension NotificationCenter {
    func postRefreshBookShelf() {
        post(name: Notification.Name.refreshBookShelf, object: nil)
    }
    
    func refreshBookShelfPublisher() -> Publisher {
        publisher(for: Notification.Name.refreshBookShelf)
    }
}
