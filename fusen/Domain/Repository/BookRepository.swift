//
//  BookRepository.swift
//  BookRepository
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import Foundation

enum BookRepositoryError: Error {
    case failedToAddBook
}

protocol BookRepository {
    func addBook(of publication: Publication, for user: User) async throws -> ID<Book>
}
