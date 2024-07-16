//
//  UpdateBookUseCase.swift
//  UpdateBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum UpdateBookUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol UpdateBookUseCase {
    func invoke(book: Book, image: ImageData?, title: String, author: String, description: String) async throws
}

public final class UpdateBookUseCaseImpl: UpdateBookUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    public init(
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    public func invoke(book: Book, image: ImageData?, title: String, author: String, description: String) async throws {
        guard let user = accountService.currentUser else {
            throw UpdateBookUseCaseError.notAuthenticated
        }
        
        do {
            if let image {
                try await bookRepository.update(book: book, image: image, for: user)
                let updatedBook = try await bookRepository.getBook(by: book.id, for: user)
                try await bookRepository.update(book: updatedBook, title: title, author: author, description: description, for: user)
            } else {
                try await bookRepository.update(book: book, title: title, author: author, description: description, for: user)
            }
        } catch {
            throw UpdateBookUseCaseError.badNetwork
        }
    }
}
