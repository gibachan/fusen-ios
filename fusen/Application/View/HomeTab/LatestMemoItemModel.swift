//
//  LatestMemoItemModel.swift
//  LatestMemoItemModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Foundation

@MainActor
final class LatestMemoItemModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    @Published var memo: Memo
    @Published var book: Book?
    @Published var state: State = .initial

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
            self.state = .succeeded
            self.book = book
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
        }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case failed
        
        var isInProgress: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }
}
