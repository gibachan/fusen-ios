//
//  UpdateMemoUseCase.swift
//  UpdateMemoUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum UpdateMemoUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol UpdateMemoUseCase {
    func invoke(memo: Memo, text: String, quote: String, page: Int, imageURLs: [URL]) async throws
}

final class UpdateMemoUseCaseImpl: UpdateMemoUseCase {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func invoke(memo: Memo, text: String, quote: String, page: Int, imageURLs: [URL]) async throws {
        guard let user = accountService.currentUser else {
            throw UpdateMemoUseCaseError.notAuthenticated
        }
        
        do {
            let memoPage: Int? = page == 0 ? nil : page
            try await memoRepository.update(memo: memo, text: text, quote: quote, page: memoPage, imageURLs: imageURLs, for: user)
        } catch {
            throw UpdateMemoUseCaseError.badNetwork
        }
    }
}
