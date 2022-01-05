//
//  UserActionHistoryRepository.swift
//  UserActionHistoryRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

protocol UserActionHistoryRepository {
    func get() async -> UserActionHistory
    
    func update(didConfirmReadingBookDescription: Bool) async
    
    func update(readBook: Book, page: Int) async
    
    func update(reviewedVersion: String) async
    
    func update(launchedAppBefore: Bool) async
    
    func clearAll() async
}
