//
//  FavoriteBookListViewModel.swift
//  FavoriteBookListViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import Foundation

final class FavoriteBookListViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    @Published var state: State = .initial
    @Published var pager: Pager<Book> = .empty
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }

    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await bookRepository.getFavoriteBooks(for: user, forceRefresh: false)
            log.d("finished=\(pager.finished)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .succeeded
                self.pager = pager
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
                NotificationCenter.default.postError(message: .network)
            }
        }
    }
    
    func onRefresh() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .refreshing
        do {
            let pager = try await bookRepository.getFavoriteBooks(for: user, forceRefresh: true)
            log.d("finished=\(pager.finished)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .succeeded
                self.pager = pager
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
                NotificationCenter.default.postError(message: .network)
            }
        }
    }
    
    func onItemApper(of book: Book) async {
        guard case .succeeded = state, !pager.finished else { return }
        guard let user = accountService.currentUser else { return }
        guard let lastBook = pager.data.last else { return }

        if book.id == lastBook.id {
            state = .loadingNext
            do {
                let pager = try await bookRepository.getFavoriteBooksNext(for: user)
                log.d("finished=\(pager.finished)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.state = .succeeded
                    self.pager = pager
                }
            } catch {
                log.e(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.state = .failed
                    NotificationCenter.default.postError(message: .network)
                }
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case loadingNext
        case refreshing
        case succeeded
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .succeeded, .failed:
                return false
            case .loading, .loadingNext, .refreshing:
                return true
            }
        }
    }
}