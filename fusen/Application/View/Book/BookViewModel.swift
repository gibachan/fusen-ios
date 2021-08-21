//
//  BookViewModel.swift
//  BookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import Foundation

final class BookViewModel: ObservableObject {
    private let bookId: ID<Book>
    private let accountService: AccountServiceProtocol
    private let userRepository: UserRepository
    private let bookRepository: BookRepository
    private let memoRepository: MemoRepository
    
    @Published var book: Book?
    @Published var isReadingBook = false
    @Published var state: State = .initial
    @Published var memoPager: Pager<Memo> = .empty
    
    init(
        bookId: ID<Book>,
        accountService: AccountServiceProtocol = AccountService.shared,
        userRepository: UserRepository = UserRepositoryImpl(),
        bookRepository: BookRepository = BookRepositoryImpl(),
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.bookId = bookId
        self.accountService = accountService
        self.userRepository = userRepository
        self.bookRepository = bookRepository
        self.memoRepository = memoRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            // async letで例外が発生したときに何故かキャッチできずにクラッシュする
//            async let userInfo = userRepository.getInfo(for: user)
//            async let newBook = bookRepository.getBook(by: book.id, for: user)
//            async let memoPager = memoRepository.getMemos(of: book, for: user, forceRefresh: false)
//            let result = try await (userInfo: userInfo, book: newBook, memoPager: memoPager)
//            DispatchQueue.main.async { [weak self] in
//                self?.state = .succeeded
//                self?.isReadingBook = result.userInfo.readingBookId == result.book.id
//                self?.book = result.book
//                self?.memoPager = result.memoPager
//            }

            let userInfo = try await userRepository.getInfo(for: user)
            let book = try await bookRepository.getBook(by: bookId, for: user)
            let memoPager = try await memoRepository.getMemos(of: bookId, for: user, forceRefresh: false)
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.isReadingBook = userInfo.readingBookId == book.id
                self?.book = book
                self?.memoPager = memoPager
            }
        } catch {
            // FIXME: error handling
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    func onItemApper(of memo: Memo) async {
        guard case .succeeded = state, !memoPager.finished else { return }
        guard let user = accountService.currentUser else { return }
        guard let lastMemo = memoPager.data.last else { return }

        if memo.id == lastMemo.id {
            state = .loadingNext
            do {
                let pager = try await memoRepository.getNextMemos(of: bookId, for: user)
                log.d("finished=\(pager.finished)")
                DispatchQueue.main.async { [weak self] in
                    self?.state = .succeeded
                    self?.memoPager = pager
                }
            } catch {
                log.e(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.state = .failed
                }
            }
        }
    }
    
    func onReadingToggle() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let readingBook: Book? = isReadingBook ? nil : book
            try await userRepository.update(readingBook: readingBook, for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.isReadingBook = readingBook != nil
            }
        } catch {
            // FIXME: error handling
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    func onFavoriteChange(isFavorite: Bool) async {
        guard let user = accountService.currentUser else { return }
        guard let book = book else { return }
        guard !state.isInProgress else { return }

        state = .loading
        do {
            try await bookRepository.update(book: book, isFavorite: isFavorite, for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
            }
        } catch {
            // FIXME: error handling
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    func onDelete() async {
        guard let user = accountService.currentUser else { return }
        guard let book = book else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await bookRepository.delete(book: book, for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .deleted
                NotificationCenter.default.postRefreshBookShelf()
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
        case loadingNext
        case succeeded
        case deleted
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .succeeded, .failed, .deleted:
                return false
            case .loading, .loadingNext:
                return true
            }
        }
    }
}
