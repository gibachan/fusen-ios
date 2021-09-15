//
//  NotificationCenterExtension.swift
//  NotificationCenterExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

extension NotificationCenter {
    func postHomePopToRoot() {
        post(name: Notification.Name.homePopToRoot, object: nil)
    }
    func postBookShelfPopToRoot() {
        post(name: Notification.Name.bookShelfPopToRoot, object: nil)
    }
    func postTutorialFinished() {
        post(name: Notification.Name.tutorialFinished, object: nil)
    }
    func postShowReadingBookDescription() {
        post(name: Notification.Name.showReadingBookDescription, object: nil)
    }
    func postError(message: ErrorMessage) {
        post(name: Notification.Name.error, object: nil, userInfo: [Notification.errorMessageParam: message])
    }
    func postRefreshBookShelfAllCollection() {
        post(name: Notification.Name.refreshBookShelfAllCollection, object: nil)
    }
    func postLogOut() {
        post(name: Notification.Name.logOut, object: nil)
    }
    
    func homePopToRootPublisher() -> Publisher {
        publisher(for: Notification.Name.homePopToRoot)
    }
    func bookShelfPopToRootPublisher() -> Publisher {
        publisher(for: Notification.Name.bookShelfPopToRoot)
    }
    func tutorialFinishedPublisher() -> Publisher {
        publisher(for: Notification.Name.tutorialFinished)
    }
    func showReadingBookDescriptionPublisher() -> Publisher {
        publisher(for: Notification.Name.showReadingBookDescription)
    }
    func errorPublisher() -> Publisher {
        publisher(for: Notification.Name.error)
    }
    func refreshBookShelfAllCollectionPublisher() -> Publisher {
        publisher(for: Notification.Name.refreshBookShelfAllCollection)
    }
    func logOutPublisher() -> Publisher {
        publisher(for: Notification.Name.logOut)
    }
}
