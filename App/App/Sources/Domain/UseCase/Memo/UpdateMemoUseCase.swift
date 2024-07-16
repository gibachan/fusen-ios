//
//  UpdateMemoUseCase.swift
//  UpdateMemoUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum UpdateMemoUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol UpdateMemoUseCase {
    func invoke(memo: Memo, text: String, quote: String, page: Int, imageURLs: [URL]) async throws
}

public final class UpdateMemoUseCaseImpl: UpdateMemoUseCase {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    public init(
        accountService: AccountServiceProtocol,
        memoRepository: MemoRepository
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    public func invoke(memo: Memo, text: String, quote: String, page: Int, imageURLs: [URL]) async throws {
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
