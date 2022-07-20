//
//  DeleteMemoUseCase.swift
//  DeleteMemoUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum DeleteMemoUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol DeleteMemoUseCase {
    func invoke(memo: Memo) async throws
}

final class DeleteMemoUseCaseImpl: DeleteMemoUseCase {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func invoke(memo: Memo) async throws {
        guard let user = accountService.currentUser else {
            throw DeleteMemoUseCaseError.notAuthenticated
        }
        
        do {
            try await memoRepository.delete(memo: memo, for: user)
        } catch {
            throw DeleteMemoUseCaseError.badNetwork
        }
    }
}
