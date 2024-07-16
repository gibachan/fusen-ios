//
//  GetAllBooksUseCase.swift
//  GetAllBooksUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum GetAllBooksUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol GetAllBooksUseCase {
    func invoke(forceRefresh: Bool) async throws -> Pager<Book>
    func invokeNext() async throws -> Pager<Book>
}

public final class GetAllBooksUseCaseImpl: GetAllBooksUseCase {
    private let sortedBy: BookSort
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    public init(sortedBy: BookSort,
                accountService: AccountServiceProtocol,
                bookRepository: BookRepository
    ) {
        self.sortedBy = sortedBy
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    public func invoke(forceRefresh: Bool) async throws -> Pager<Book> {
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
    
    public func invokeNext() async throws -> Pager<Book> {
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
