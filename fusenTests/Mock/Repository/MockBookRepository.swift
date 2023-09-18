//
//  MockBookRepository.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/11/18.
//

import Foundation
import Domain
@testable import fusen

final class MockBookRepository: BookRepository {
    private let getAllBooksCountResult: Int
    private(set) var isBookDataUpdated = false
    private(set) var isBookImageUpdated = false

    init(
        getAllBooksCountResult: Int = 0
    ) {
        self.getAllBooksCountResult = getAllBooksCountResult
    }
    
    func getBook(by id: ID<Book>, for user: User) async throws -> Book {
        Book.sample
    }
    
    func getLatestBooks(count: Int, for user: User) async throws -> [Book] {
        fatalError("Not implemented yet")
    }
    
    func getAllBooks(sortedBy: BookSort, for user: User, forceRefresh: Bool) async throws -> Pager<Book> {
        fatalError("Not implemented yet")
    }
    
    func getAllBooksNext(for user: User) async throws -> Pager<Book> {
        fatalError("Not implemented yet")
    }
    
    func getFavoriteBooks(for user: User, forceRefresh: Bool) async throws -> Pager<Book> {
        fatalError("Not implemented yet")
    }
    
    func getFavoriteBooksNext(for user: User) async throws -> Pager<Book> {
        fatalError("Not implemented yet")
    }
    
    func getBooks(by collection: Collection, sortedBy: BookSort, for user: User, forceRefresh: Bool) async throws -> Pager<Book> {
        fatalError("Not implemented yet")
    }
    
    func getBooksNext(by collection: Collection, for user: User) async throws -> Pager<Book> {
        fatalError("Not implemented yet")
    }
    
    func addBook(of publication: Publication, in collection: Collection?, image: ImageData?, for user: User) async throws -> ID<Book> {
        fatalError("Not implemented yet")
    }
    
    func update(book: Book, isFavorite: Bool, for user: User) async throws {
        fatalError("Not implemented yet")
    }
    
    func update(book: Book, title: String, author: String, description: String, for user: User) async throws {
        isBookDataUpdated = true
    }
    
    func update(book: Book, collection: Collection, for user: User) async throws {
        fatalError("Not implemented yet")
    }
    
    func update(book: Book, image: ImageData, for user: User) async throws {
        isBookImageUpdated = true
    }
    
    func delete(book: Book, for user: User) async throws {
        fatalError("Not implemented yet")
    }

    func getAllBooksCount(for user: fusen.User) async throws -> Int {
        return getAllBooksCountResult
    }
}
