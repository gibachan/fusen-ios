//
//  ReadBookUseCase.swift
//  ReadBookUseCase
//
//  Created by Tatsuyuki Kobayashi on 2021/09/09.
//

import Foundation

protocol ReadBookUseCase {
    func invoke(book: Book, page: Int)
}

final class ReadBookUseCaseImpl: ReadBookUseCase {
    private let userActionHistoryRepository: UserActionHistoryRepository
    
    init(
        userActionHistoryRepository: UserActionHistoryRepository = UserActionHistoryRepositoryImpl()
    ) {
        self.userActionHistoryRepository = userActionHistoryRepository
    }
    
    func invoke(book: Book, page: Int) {
        userActionHistoryRepository.update(readBook: book, page: page)
    }
}
