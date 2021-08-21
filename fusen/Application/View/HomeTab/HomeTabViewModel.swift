//
//  HomeTabViewModel.swift
//  HomeTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Foundation

final class HomeTabViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let userRepository: UserRepository
    private let bookRepository: BookRepository
    private let memoRepository: MemoRepository
    
    @Published var state: State = .initial
    @Published var readingBook: Book?
    @Published var latestBooks: [Book] = []
    @Published var latestMemos: [Memo] = []
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        userRepository: UserRepository = UserRepositoryImpl(),
        bookRepository: BookRepository = BookRepositoryImpl(),
        memoRpository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.accountService = accountService
        self.userRepository = userRepository
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
            let userInfo = try await userRepository.getInfo(for: user)
            
            async let books = bookRepository.getLatestBooks(for: user)
            async let memos = memoRepository.getLatestMemos(for: user)
            let result = try await (books: books, memos: memos)
            if let readingBookId = userInfo.readingBookId {
                let readingBook = try await bookRepository.getBook(by: readingBookId, for: user)
                DispatchQueue.main.async { [weak self] in
                    self?.readingBook = readingBook
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.readingBook = nil
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.latestBooks = Array(result.books.prefix(4))
                self?.latestMemos = Array(result.memos.prefix(4))
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
