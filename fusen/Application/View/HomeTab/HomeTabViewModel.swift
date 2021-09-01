//
//  HomeTabViewModel.swift
//  HomeTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Foundation

@MainActor
final class HomeTabViewModel: ObservableObject {
    private let latestBooksCount = 4
    private let latestMemosCount = 4
    
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
            
            async let books = bookRepository.getLatestBooks(count: latestBooksCount, for: user)
            async let memos = memoRepository.getLatestMemos(count: latestMemosCount, for: user)
            let result = try await (books: books, memos: memos)
            if let readingBookId = userInfo.readingBookId {
                do {
                    readingBook = try await bookRepository.getBook(by: readingBookId, for: user)
                } catch {
                    // Reaches when the readingBook has been already deleted which is unexpected situation.
                    log.e(error.localizedDescription)
                    readingBook = nil
                }
            } else {
                readingBook = nil
            }
            if result.books.isEmpty && result.memos.isEmpty {
                state = .empty
            } else {
                state = .loaded(latestBooks: result.books, latestMemos: result.memos)
            }
        } catch {
            log.e(error.localizedDescription)
            state = .failed
            NotificationCenter.default.postError(message: .network)
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
