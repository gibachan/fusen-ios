//
//  AddDraftMemoUseCase.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/16.
//

import Foundation

enum AddDraftMemoUseCaseError: Error {
    case notAuthenticated
    case draftIsNotFound
    case badNetwork
}

protocol AddDraftMemoUseCase {
    func invoke() async throws -> ID<Memo>
}

final class AddDraftMemoUseCaseImpl: AddDraftMemoUseCase {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    init(accountService: AccountServiceProtocol = AccountService.shared,
         memoRepository: MemoRepository = MemoRepositoryImpl()) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func invoke() async throws -> ID<Memo> {
        guard let user = accountService.currentUser else {
            throw AddDraftMemoUseCaseError.notAuthenticated
        }
        guard let draft = await memoRepository.getDraft() else {
            throw AddDraftMemoUseCaseError.draftIsNotFound
        }
        
        do {
            let memoPage: Int?
            if let page = draft.page,
               page > 0 {
                memoPage = page
            } else {
                memoPage = nil
            }
            let memoId = try await memoRepository.addMemo(bookId: draft.bookId,
                                                          text: draft.text,
                                                          quote: draft.quote,
                                                          page: memoPage,
                                                          image: nil,
                                                          for: user)
            await memoRepository.setDraft(nil)
            return memoId
        } catch {
            throw AddDraftMemoUseCaseError.badNetwork
        }
    }
}
