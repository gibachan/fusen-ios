//
//  AddBookByManualUseCase.swift
//  AddBookByManualUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum AddBookByManualUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol AddBookByManualUseCase {
    func invoke(title: String, author: String, thumbnailImage: ImageData?, collection: Collection?) async throws -> ID<Book>
}

public final class AddBookByManualUseCaseImpl: AddBookByManualUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    public init(
        accountService: AccountServiceProtocol,
        bookRepository: BookRepository
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    public func invoke(title: String, author: String, thumbnailImage: ImageData?, collection: Collection?) async throws -> ID<Book> {
        guard let user = accountService.currentUser else {
            throw AddBookByManualUseCaseError.notAuthenticated
        }
        
        let publication = Publication(
            title: title,
            author: author,
            thumbnailURL: nil
        )
       
        do {
            return try await bookRepository.addBook(of: publication, in: collection, image: thumbnailImage, for: user)
        } catch {
            throw AddBookByManualUseCaseError.badNetwork
        }
    }
}
