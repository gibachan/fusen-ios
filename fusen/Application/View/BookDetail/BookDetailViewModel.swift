//
//  BookDetailViewModel.swift
//  BookDetailViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import Foundation

final class BookDetailViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    @Published var book: Book
    @Published var state: State = .initial
    
    init(book: Book,
         accountService: AccountServiceProtocol = AccountService.shared,
         bookRepository: BookRepository = BookRepositoryImpl()) {
        self.book = book
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onFavoriteChange(isFavorite: Bool) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isLoading else { return }

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
        guard !state.isLoading else { return }
        
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
        case succeeded
        case deleted
        case failed
        
        var isLoading: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }
}
