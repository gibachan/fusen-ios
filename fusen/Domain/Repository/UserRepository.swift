//
//  UserRepository.swift
//  UserRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Foundation

enum UserRepositoryError: Error {
    case unknown
}

protocol UserRepository {
    func getInfo(for user: User) async throws -> UserInfo
    
    func update(readingBook book: Book?, for user: User) async throws
}
