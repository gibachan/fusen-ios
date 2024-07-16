//
//  UserRepository.swift
//  UserRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Foundation

public enum UserRepositoryError: Error {
    case network
}

public protocol UserRepository {
    func getInfo(for user: User) async throws -> UserInfo
    
    func update(readingBook book: Book?, for user: User) async throws
}
