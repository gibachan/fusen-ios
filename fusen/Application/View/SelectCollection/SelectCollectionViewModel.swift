//
//  SelectCollectionViewModel.swift
//  SelectCollectionViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Foundation

final class SelectCollectionViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    private let collectionRepository: CollectionRepository
    
    @Published var state: State = .initial
    @Published var book: Book
    @Published var collections: [Collection] = []
    
    init(
        book: Book,
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl(),
        collectionRepository: CollectionRepository = CollectionRepositoryImpl()
    ) {
        self.book = book
        self.accountService = accountService
        self.bookRepository = bookRepository
        self.collectionRepository = collectionRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let collections = try await collectionRepository.getlCollections(for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .loaded
                self?.collections = [collections, [Collection.default]].flatMap { $0 }
            }
        } catch {
            // FIXME: error handling
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    func onSelect(collection: Collection) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await bookRepository.update(book: book, collection: collection, for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .updated
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
        case loaded
        case updated
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .updated, .failed:
                return false
            case .loading:
                return true
            }
        }
    }
}