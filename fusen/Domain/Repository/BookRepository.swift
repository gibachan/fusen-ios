//
//  BookRepository.swift
//  BookRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

enum BookRepositoryError: Error {
    case uploadImage
    case network
}

protocol BookRepository {
    func getBook(by id: ID<Book>, for user: User) async throws -> Book
    func getLatestBooks(count: Int, for user: User) async throws -> [Book]

    func getAllBooksCount(for user: User) async throws -> Int
    func getAllBooks(sortedBy: BookSort, for user: User, forceRefresh: Bool) async throws -> Pager<Book>
    func getAllBooksNext(for user: User) async throws -> Pager<Book>
    
    func getFavoriteBooks(for user: User, forceRefresh: Bool) async throws -> Pager<Book>
    func getFavoriteBooksNext(for user: User) async throws -> Pager<Book>

    func getBooks(by collection: Collection, sortedBy: BookSort, for user: User, forceRefresh: Bool) async throws -> Pager<Book>
    func getBooksNext(by collection: Collection, for user: User) async throws -> Pager<Book>
    
    func addBook(of publication: Publication, in collection: Collection?, image: ImageData?, for user: User) async throws -> ID<Book>
    func update(book: Book, isFavorite: Bool, for user: User) async throws
    func update(book: Book, title: String, author: String, description: String, for user: User) async throws
    func update(book: Book, collection: Collection, for user: User) async throws
    func update(book: Book, image: ImageData, for user: User) async throws
    func delete(book: Book, for user: User) async throws
}
