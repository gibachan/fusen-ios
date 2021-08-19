//
//  MemoListItemModel.swift
//  MemoListItemModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import Foundation

final class MemoListItemModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    @Published var memo: Memo
    @Published var book: Book?
    @Published var state: State = .initial
    @Published var memoPager: Pager<Memo> = .empty
    
    init(
        memo: Memo,
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl(),
        memoRepository: MemoRepository = MemoRepositoryImpl()
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
                self?.state = .succeeded
                self?.book = book
            }
        } catch {
            // FIXME: error handling
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .succeeded, .failed:
                return false
            case .loading:
                return true
            }
        }
    }
}
