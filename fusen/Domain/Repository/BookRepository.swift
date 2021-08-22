//
//  BookRepository.swift
//  BookRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

enum BookRepositoryError: Error {
    case decodeError
    case unknown
}

protocol BookRepository {
    func getBook(by id: ID<Book>, for user: User) async throws -> Book
    func getLatestBooks(for user: User) async throws -> [Book]

    func getAllBooks(for user: User, forceRefresh: Bool) async throws -> Pager<Book>
    func getAllBooksNext(for user: User) async throws -> Pager<Book>
    
    func getFavoriteBooks(for user: User, forceRefresh: Bool) async throws -> Pager<Book>
    func getFavoriteBooksNext(for user: User) async throws -> Pager<Book>

    func getBooks(by collection: Collection, for user: User, forceRefresh: Bool) async throws -> Pager<Book>
    
    func addBook(of publication: Publication, in collection: Collection?, for user: User) async throws -> ID<Book>
    func update(book: Book, isFavorite: Bool, for user: User) async throws
    func update(book: Book, collection: Collection, for user: User) async throws
    func delete(book: Book, for user: User) async throws
}

extension BookRepository {
    func getAllBooks(for user: User, forceRefresh: Bool = false) async throws -> Pager<Book> {
        return try await getAllBooks(for: user, forceRefresh: forceRefresh)
    }
}
