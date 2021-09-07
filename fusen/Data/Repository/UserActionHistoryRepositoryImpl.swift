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
        return UserActionHistory(didConfirmReadingBookDescription: didConfirmReadingBookDescription)
    }
 
    func update(didConfirmReadingBookDescription: Bool) async {
        dataSource.didConfirmReadingBookDescription = didConfirmReadingBookDescription
    }
}
