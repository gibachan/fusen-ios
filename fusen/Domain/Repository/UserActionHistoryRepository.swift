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
}