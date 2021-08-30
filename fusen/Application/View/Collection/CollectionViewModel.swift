//
//  CollectionViewModel.swift
//  CollectionViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import Foundation

final class CollectionViewModel: ObservableObject {
    private let collection: Collection
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    private let collectionRepository: CollectionRepository
    
    @Published var state: State = .initial
    @Published var pager: Pager<Book> = .empty
    
    init(
        collection: Collection,
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl(),
        collectionRepository: CollectionRepository = CollectionRepositoryImpl()
    ) {
        self.collection = collection
        self.accountService = accountService
        self.bookRepository = bookRepository
        self.collectionRepository = collectionRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await bookRepository.getBooks(by: collection, for: user, forceRefresh: false)
            log.d("finished=\(pager.finished)")
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.pager = pager
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
            let pager = try await bookRepository.getBooks(by: collection, for: user, forceRefresh: true)
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
                let pager = try await bookRepository.getBooksNext(by: collection, for: user)
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
                }
            }
        }
    }
    
    func onDelete() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await collectionRepository.delete(collection: collection, for: user)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .deleted
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
                NotificationCenter.default.postError(message: .deleteCollection)
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case loadingNext
        case refreshing
        case succeeded
        case deleted
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .succeeded, .deleted, .failed:
                return false
            case .loading, .loadingNext, .refreshing:
                return true
            }
        }
    }
}
