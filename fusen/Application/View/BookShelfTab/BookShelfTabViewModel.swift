//
//  BookShelfTabViewModel.swift
//  BookShelfTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import Foundation

final class BookShelfTabViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    private let collectionRepository: CollectionRepository
    
    @Published var state: State = .initial
    @Published var isFavoriteVisible = false
    @Published var collections: [Collection] = []
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl(),
        collectionRepository: CollectionRepository = CollectionRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
        self.collectionRepository = collectionRepository
    }
    
    func onAppear() async {
        await getCollections()
    }
    
    func onRefresh() async {
        await getCollections()
    }
    
    private func getCollections() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let favoriteBooks = try await bookRepository.getFavoriteBooks(for: user, forceRefresh: true)
            let collections = try await collectionRepository.getlCollections(for: user)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .succeeded
                self.isFavoriteVisible = !favoriteBooks.data.isEmpty
                self.collections = collections
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
            }
        }
    }
    
    // associated valueに変更があってもSwiftUIは検知してくれない
    // (state自体が変更されない限りViewが更新されない）
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
