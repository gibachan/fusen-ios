//
//  GetMemosUseCase.swift
//  GetMemosUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum GetMemosUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol GetMemosUseCase {
    func invoke(forceRefresh: Bool) async throws -> Pager<Memo>
    func invokeNext() async throws -> Pager<Memo>
}

final class GetMemosUseCaseImpl: GetMemosUseCase {
    private let bookId: ID<Book>
    private let sortedBy: MemoSort
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    init(
        bookId: ID<Book>,
        sortedBy: MemoSort,
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.bookId = bookId
        self.sortedBy = sortedBy
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func invoke(forceRefresh: Bool) async throws -> Pager<Memo> {
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
    
    func invokeNext() async throws -> Pager<Memo> {
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
