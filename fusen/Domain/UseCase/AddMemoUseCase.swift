//
//  AddMemoUseCase.swift
//  AddMemoUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

enum AddMemoUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

protocol AddMemoUseCase {
    func invoke(book: Book, text: String, quote: String, page: Int, image: ImageData?) async throws -> ID<Memo>
}

final class AddMemoUseCaseImpl: AddMemoUseCase {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func invoke(book: Book, text: String, quote: String, page: Int, image: ImageData?) async throws -> ID<Memo> {
        guard let user = accountService.currentUser else {
            throw AddCollectionUseCaseError.notAuthenticated
        }
        
        do {
            let memoPage: Int? = page == 0 ? nil : page
            return try await memoRepository.addMemo(of: book, text: text, quote: quote, page: memoPage, image: image, for: user)
        } catch {
            throw AddMemoUseCaseError.badNetwork
        }
    }
}
