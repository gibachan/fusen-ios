//
//  ReadBookUseCase.swift
//  ReadBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/09.
//

import Foundation

public protocol ReadBookUseCase {
    func invoke(book: Book, page: Int)
}

public final class ReadBookUseCaseImpl: ReadBookUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository

    public init(
        userActionHistoryRepository: UserActionHistoryRepository
    ) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }

    public func invoke(book: Book, page: Int) {
        userActionHistoryRepository.update(readBook: book, page: page)
    }
}
