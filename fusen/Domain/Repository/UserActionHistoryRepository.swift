//
//  UserActionHistoryRepository.swift
//  UserActionHistoryRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/09/07.
//

import Foundation

protocol UserActionHistoryRepository {
    func get() -> UserActionHistory
    
    func update(didConfirmReadingBookDescription: Bool)
    
    func update(readBook: Book, page: Int)
    
    func update(reviewedVersion: String)
    
    func update(launchedAppBefore: Bool)
    
    func update(currentBookSort: BookSort)
    
    func update(currentMemoSort: MemoSort)
    
    func clearAll()
}
