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
    func getLatestBooks(for user: User) async throws -> [Book]
    func getBooks(for user: User, forceRefresh: Bool) async throws -> Pager<Book>
    func getNextBooks(for user: User) async throws -> Pager<Book>
    
    func addBook(of publication: Publication, for user: User) async throws -> ID<Book>
    func update(book: Book, for user: User, isFavorite: Bool) async throws
    func delete(book: Book, for user: User) async throws
}

extension BookRepository {
    func getBooks(for user: User, forceRefresh: Bool = false) async throws -> Pager<Book> {
        return try await getBooks(for: user, forceRefresh: forceRefresh)
    }
}
