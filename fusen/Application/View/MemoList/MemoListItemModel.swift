//
//  MemoListItemModel.swift
//  MemoListItemModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import Foundation

final class MemoListItemModel: ObservableObject {
    private let memo: Memo
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    private var state: State = .initial

    @Published var bookTitle: String = ""
    
    init(
        memo: Memo,
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.memo = memo
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let book = try await bookRepository.getBook(by: memo.bookId, for: user)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .loaded(book: book)
                self.bookTitle = book.title
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case loaded(book: Book)
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .failed:
                return false
            case .loading:
                return true
            }
        }
    }
}
