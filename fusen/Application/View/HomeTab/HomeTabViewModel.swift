//
//  HomeTabViewModel.swift
//  HomeTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Foundation

final class HomeTabViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    private let memoRepository: MemoRepository
    
    @Published var state: State = .initial
    @Published var latestBooks: [Book] = []
    @Published var latestMemos: [Memo] = []
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl(),
        memoRpository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
        self.memoRepository = memoRpository
    }
    
    func onAppear() async {
        await loadAll()
    }
    
    func onRefresh() async {
        await loadAll()
    }
    
    private func loadAll() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            async let books = bookRepository.getLatestBooks(for: user)
            async let memos = memoRepository.getLatestMemos(for: user)
            let result = (books: try await books, memos: try await memos)
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.latestBooks = result.books
                self?.latestMemos = result.memos
            }
        } catch {
            log.e(error.localizedDescription)
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
