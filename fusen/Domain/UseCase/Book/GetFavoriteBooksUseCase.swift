//
//  GetFavoriteBooksUseCase.swift
//  GetFavoriteBooksUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum GetFavoriteBooksUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol GetFavoriteBooksUseCase {
    func invoke(forceRefresh: Bool) async throws -> Pager<Book>
    func invokeNext() async throws -> Pager<Book>
}

final class GetFavoriteBooksUseCaseImpl: GetFavoriteBooksUseCase {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func invoke(forceRefresh: Bool) async throws -> Pager<Book> {
        guard let user = accountService.currentUser else {
            throw GetFavoriteBooksUseCaseError.notAuthenticated
        }
       
        do {
            let pager = try await bookRepository.getFavoriteBooks(for: user, forceRefresh: forceRefresh)
            return pager
        } catch {
            throw GetFavoriteBooksUseCaseError.badNetwork
        }
    }
    
    func invokeNext() async throws -> Pager<Book> {
        guard let user = accountService.currentUser else {
            throw GetFavoriteBooksUseCaseError.notAuthenticated
        }
       
        do {
            let pager = try await bookRepository.getFavoriteBooksNext(for: user)
            return pager
        } catch {
            throw GetFavoriteBooksUseCaseError.badNetwork
        }
    }
}
