//
//  BookShelfTabViewModel.swift
//  BookShelfTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import Data
import Domain
import Foundation

final class BookShelfTabViewModel: ObservableObject {
    private let getFavoriteBooksUseCase: GetFavoriteBooksUseCase
    private let getCollectionsUseCase: GetCollectionsUseCase
    private let getBooksCountUseCase: GetBooksCountUseCase
    
    @Published var state: State = .initial
    @Published var isFavoriteVisible = false
    @Published var collections: [Domain.Collection] = []
    @Published var booksCount = ""
    
    init(
        getFavoriteBooksUseCase: GetFavoriteBooksUseCase = GetFavoriteBooksUseCaseImpl(accountService: AccountService.shared, bookRepository: BookRepositoryImpl()),
        getCollectionsUseCase: GetCollectionsUseCase = GetCollectionsUseCaseImpl(accountService: AccountService.shared, collectionRepository: CollectionRepositoryImpl()),
        getBooksCountUseCase: GetBooksCountUseCase = GetBooksCountUseCaseImpl(accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
    ) {
        self.getFavoriteBooksUseCase = getFavoriteBooksUseCase
        self.getCollectionsUseCase = getCollectionsUseCase
        self.getBooksCountUseCase = getBooksCountUseCase
    }
    
    func onAppear() async {
        await refresh()
    }
    
    func onRefresh() async {
        await refresh()
    }
    
    @MainActor
    private func refresh() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let favoriteBooks = try await getFavoriteBooksUseCase.invoke(forceRefresh: true)
            let collections = try await getCollectionsUseCase.invoke()
            let booksCount = try await getBooksCountUseCase.invoke()
            self.state = .succeeded
            self.isFavoriteVisible = !favoriteBooks.data.isEmpty
            self.collections = collections
            self.booksCount = booksCount > 0 ? "書籍 \(booksCount.localizedString)冊" : ""
        } catch {
            log.e(error.localizedDescription)
            state = .failed
        }
    }
    
    // associated valueに変更があってもSwiftUIは検知してくれない
    // (state自体が変更されない限りViewが更新されない）
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
