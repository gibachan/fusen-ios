//
//  AddMemoUseCase.swift
//  AddMemoUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/05.
//

import Foundation

public enum AddMemoUseCaseError: Error {
    case notAuthenticated
    case badNetwork
}

public protocol AddMemoUseCase {
    func invoke(book: Book, text: String, quote: String, page: Int, image: ImageData?) async throws -> ID<Memo>
}

public final class AddMemoUseCaseImpl: AddMemoUseCase {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository

    public init(
        accountService: AccountServiceProtocol,
        memoRepository: MemoRepository
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }

    public func invoke(book: Book, text: String, quote: String, page: Int, image: ImageData?) async throws -> ID<Memo> {
        guard let user = accountService.currentUser else {
            throw AddMemoUseCaseError.notAuthenticated
        }

        do {
            let memoPage: Int? = page == 0 ? nil : page
            return try await memoRepository.addMemo(bookId: book.id, text: text, quote: quote, page: memoPage, image: image, for: user)
        } catch {
            throw AddMemoUseCaseError.badNetwork
        }
    }
}
