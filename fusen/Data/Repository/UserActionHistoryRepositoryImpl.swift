//
//  UserActionHistoryRepositoryImpl.swift
//  UserActionHistoryRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

final class UserActionHistoryRepositoryImpl: UserActionHistoryRepository {
    let dataSource = UserDefaultsDataSource()
    
    func get() async -> UserActionHistory {
        let didConfirmReadingBookDescription = dataSource.didConfirmReadingBookDescription
        var readBook: [ID<Book>: Int] = [:]
        dataSource.readBook
            .forEach { key, value in
                guard let page = value as? Int else { return }
                readBook[ID<Book>(value: key)] = page
            }
        return UserActionHistory(didConfirmReadingBookDescription: didConfirmReadingBookDescription, readBook: readBook)
    }
    
    func update(didConfirmReadingBookDescription: Bool) async {
        dataSource.didConfirmReadingBookDescription = didConfirmReadingBookDescription
    }
    
    func update(readBook: Book, page: Int) async {
        dataSource.setReadPage(for: readBook, page: page)
    }
}
