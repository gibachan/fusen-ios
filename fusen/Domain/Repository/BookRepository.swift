//
//  BookRepository.swift
//  BookRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

enum BookRepositoryError: Error {
    case unknwon
}

protocol BookRepository {
    func getBooks(for user: User, forceRefresh: Bool) async throws -> Pager<Book>
    func getNextBooks(for user: User) async throws -> Pager<Book>
    
    func addBook(of publication: Publication, for user: User) async throws -> ID<Book>
}

extension BookRepository {
    func getBooks(for user: User, forceRefresh: Bool = false) async throws -> Pager<Book> {
        return try await getBooks(for: user, forceRefresh: forceRefresh)
    }
}
