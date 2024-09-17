//
//  DeleteMemoUseCase.swift
//  DeleteMemoUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum DeleteMemoUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol DeleteMemoUseCase {
    func invoke(memo: Memo) async throws
}

public final class DeleteMemoUseCaseImpl: DeleteMemoUseCase {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository

    public init(
        accountService: AccountServiceProtocol,
        memoRepository: MemoRepository
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }

    public func invoke(memo: Memo) async throws {
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
