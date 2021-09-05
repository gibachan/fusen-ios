//
//  GetAllBooksUseCase.swift
//  GetAllBooksUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum GetAllBooksUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol GetAllBooksUseCase {
    func invoke(forceRefresh: Bool) async throws -> Pager<Book>
    func invokeNext() async throws -> Pager<Book>
}

final class GetAllBooksUseCaseImpl: GetAllBooksUseCase {
    private let sortedBy: BookSort
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    init(sortedBy: BookSort,
         accountService: AccountServiceProtocol = AccountService.shared,
         bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.sortedBy = sortedBy
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func invoke(forceRefresh: Bool) async throws -> Pager<Book> {
        guard let user = accountService.currentUser else {
            throw GetAllBooksUseCaseError.notAuthenticated
        }
       
        do {
            let pager = try await bookRepository.getAllBooks(sortedBy: sortedBy, for: user, forceRefresh: forceRefresh)
            return pager
        } catch {
            throw GetAllBooksUseCaseError.badNetwork
        }
    }
    
    func invokeNext() async throws -> Pager<Book> {
        guard let user = accountService.currentUser else {
            throw GetAllBooksUseCaseError.notAuthenticated
        }
       
        do {
            let pager = try await bookRepository.getAllBooksNext(for: user)
            return pager
        } catch {
            throw GetAllBooksUseCaseError.badNetwork
        }
    }
}
