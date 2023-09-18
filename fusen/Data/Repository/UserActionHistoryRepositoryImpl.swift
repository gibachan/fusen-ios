//
//  UserActionHistoryRepositoryImpl.swift
//  UserActionHistoryRepositoryImpl
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Domain
import Foundation

final class UserActionHistoryRepositoryImpl: UserActionHistoryRepository {
    private let dataSource: UserDefaultsDataSource
    
    init(dataSource: UserDefaultsDataSource = UserDefaultsDataSourceImpl()) {
        self.dataSource = dataSource
    }
    
    func get() -> UserActionHistory {
        var readBook: [ID<Book>: Int] = [:]
        dataSource.readBookPages
            .forEach { key, value in
                guard let page = value as? Int else { return }
                readBook[ID<Book>(stringLiteral: key)] = page
            }
        return UserActionHistory(
            launchedAppBefore: dataSource.launchedAppBefore,
            didConfirmReadingBookDescription: dataSource.didConfirmReadingBookDescription,
            readBookPages: readBook,
            reviewedVersion: dataSource.reviewedVersion,
            currentBookSort: dataSource.currentBookSort,
            currentMemoSort: dataSource.currentMemoSort
        )
    }
    
    func update(didConfirmReadingBookDescription: Bool) {
        dataSource.didConfirmReadingBookDescription = didConfirmReadingBookDescription
    }
    
    func update(readBook: Book, page: Int) {
        dataSource.setReadPage(for: readBook, page: page)
    }
    
    func update(reviewedVersion: String) {
        dataSource.reviewedVersion = reviewedVersion
    }
    
    func update(launchedAppBefore: Bool) {
        dataSource.launchedAppBefore = launchedAppBefore
    }
    
    func update(currentBookSort: BookSort) {
        dataSource.currentBookSort = currentBookSort
    }
    
    func update(currentMemoSort: MemoSort) {
        dataSource.currentMemoSort = currentMemoSort
    }
    
    func clearAll() {
        dataSource.didConfirmReadingBookDescription = false
        dataSource.reviewedVersion = ""
        dataSource.currentBookSort = nil
        dataSource.currentMemoSort = nil
    }
}
