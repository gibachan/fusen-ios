//
//  BookViewModel.swift
//  BookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import Foundation

final class BookViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    private let memoRepository: MemoRepository
    
    @Published var book: Book
    @Published var state: State = .initial
    @Published var memoPager: Pager<Memo> = .empty
    
    init(
        book: Book,
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl(),
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.book = book
        self.accountService = accountService
        self.bookRepository = bookRepository
        self.memoRepository = memoRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            async let newBook = try await bookRepository.getBook(by: book.id, for: user)
            async let memoPager = memoRepository.getMemos(of: book, for: user, forceRefresh: false)
            let result = (book: try await newBook, memoPager: try await memoPager)
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.book = result.book
                self?.memoPager = result.memoPager
            }
        } catch {
            // FIXME: error handling
            print(error.localizedDescription)
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
                let pager = try await memoRepository.getNextMemos(of: book, for: user)
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
    
    func onFavoriteChange(isFavorite: Bool) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await bookRepository.update(book: book, for: user, isFavorite: isFavorite)
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
