//
//  GetAllMemosUseCase.swift
//  GetAllMemosUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum GetAllMemosUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol GetAllMemosUseCase {
    func invoke(forceRefresh: Bool) async throws -> Pager<Memo>
    func invokeNext() async throws -> Pager<Memo>
}

public final class GetAllMemosUseCaseImpl: GetAllMemosUseCase {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    public init(
         accountService: AccountServiceProtocol,
         memoRepository: MemoRepository
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    public func invoke(forceRefresh: Bool) async throws -> Pager<Memo> {
        guard let user = accountService.currentUser else {
            throw GetAllMemosUseCaseError.notAuthenticated
        }
       
        do {
            let pager = try await memoRepository.getAllMemos(for: user, forceRefresh: forceRefresh)
            return pager
        } catch {
            throw GetAllMemosUseCaseError.badNetwork
        }
    }
    
    public func invokeNext() async throws -> Pager<Memo> {
        guard let user = accountService.currentUser else {
            throw GetAllMemosUseCaseError.notAuthenticated
        }
       
        do {
            let pager = try await memoRepository.getAllMemosNext(for: user)
            return pager
        } catch {
            throw GetAllMemosUseCaseError.badNetwork
        }
    }
}
