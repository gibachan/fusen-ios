//
//  GetAllMemosUseCase.swift
//  GetAllMemosUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum GetAllMemosUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol GetAllMemosUseCase {
    func invoke(forceRefresh: Bool) async throws -> Pager<Memo>
    func invokeNext() async throws -> Pager<Memo>
}

final class GetAllMemosUseCaseImpl: GetAllMemosUseCase {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    init(
         accountService: AccountServiceProtocol = AccountService.shared,
         memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func invoke(forceRefresh: Bool) async throws -> Pager<Memo> {
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
    
    func invokeNext() async throws -> Pager<Memo> {
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
