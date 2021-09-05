//
//  AddBookByManualUseCase.swift
//  AddBookByManualUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum AddBookByManualUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol AddBookByManualUseCase {
    func invoke(title: String, author: String, thumbnailImage: ImageData?, collection: Collection?) async throws -> ID<Book>
}

final class AddBookByManualUseCaseImpl: AddBookByManualUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func invoke(title: String, author: String, thumbnailImage: ImageData?, collection: Collection?) async throws -> ID<Book> {
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
