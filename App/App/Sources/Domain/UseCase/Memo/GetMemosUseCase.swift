//
//  GetMemosUseCase.swift
//  GetMemosUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum GetMemosUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol GetMemosUseCase {
    func invoke(forceRefresh: Bool) async throws -> Pager<Memo>
    func invokeNext() async throws -> Pager<Memo>
}

public final class GetMemosUseCaseImpl: GetMemosUseCase {
    private let bookId: ID<Book>
    private let sortedBy: MemoSort
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    public init(
        bookId: ID<Book>,
        sortedBy: MemoSort,
        accountService: AccountServiceProtocol,
        memoRepository: MemoRepository
    ) {
        self.bookId = bookId
        self.sortedBy = sortedBy
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    public func invoke(forceRefresh: Bool) async throws -> Pager<Memo> {
        guard let user = accountService.currentUser else {
            throw GetMemosUseCaseError.notAuthenticated
        }
        
        do {
            let pager = try await memoRepository.getMemos(of: bookId, sortedBy: sortedBy, for: user, forceRefresh: forceRefresh)
            return pager
        } catch {
            throw GetMemosUseCaseError.badNetwork
        }
    }
    
    public func invokeNext() async throws -> Pager<Memo> {
        guard let user = accountService.currentUser else {
            throw GetMemosUseCaseError.notAuthenticated
        }
        
        do {
            let pager = try await memoRepository.getNextMemos(of: bookId, for: user)
            return pager
        } catch {
            throw GetMemosUseCaseError.badNetwork
        }
    }
}
