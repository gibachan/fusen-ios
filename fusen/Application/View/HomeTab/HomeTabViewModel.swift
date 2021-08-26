//
//  HomeTabViewModel.swift
//  HomeTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Foundation

final class HomeTabViewModel: ObservableObject {
    private let visibleLatestBooksLimit = 4
    private let visibleLatestMemosLimit = 4
    
    private let accountService: AccountServiceProtocol
    private let userRepository: UserRepository
    private let bookRepository: BookRepository
    private let memoRepository: MemoRepository
    
    @Published var state: State = .initial
    @Published var readingBook: Book?
    
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
                    guard let self = self else { return }
                    self.readingBook = readingBook
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.readingBook = nil
                }
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if result.books.isEmpty && result.memos.isEmpty {
                    self.state = .empty
                } else {
                    self.state = .loaded(latestBooks: Array(result.books.prefix(self.visibleLatestBooksLimit)), latestMemos: Array(result.memos.prefix(self.visibleLatestMemosLimit)))
                }
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
        case loaded(latestBooks: [Book], latestMemos: [Memo])
        case empty
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .empty, .failed:
                return false
            case .loading:
                return true
            }
        }
    }
}
