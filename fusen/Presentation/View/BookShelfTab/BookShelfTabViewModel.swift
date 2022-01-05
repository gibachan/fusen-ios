//
//  BookShelfTabViewModel.swift
//  BookShelfTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import Foundation

final class BookShelfTabViewModel: ObservableObject {
    private let getFavoriteBooksUseCase: GetFavoriteBooksUseCase
    private let getCollectionsUseCase: GetCollectionsUseCase
    
    @Published var state: State = .initial
    @Published var isFavoriteVisible = false
    @Published var collections: [Collection] = []
    
    init(
        getFavoriteBooksUseCase: GetFavoriteBooksUseCase = GetFavoriteBooksUseCaseImpl(),
        getCollectionsUseCase: GetCollectionsUseCase = GetCollectionsUseCaseImpl()
    ) {
        self.getFavoriteBooksUseCase = getFavoriteBooksUseCase
        self.getCollectionsUseCase = getCollectionsUseCase
    }
    
    func onAppear() async {
        await getCollections()
    }
    
    func onRefresh() async {
        await getCollections()
    }
    
    @MainActor
    private func getCollections() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let favoriteBooks = try await getFavoriteBooksUseCase.invoke(forceRefresh: true)
            let collections = try await getCollectionsUseCase.invoke()
            self.state = .succeeded
            self.isFavoriteVisible = !favoriteBooks.data.isEmpty
            self.collections = collections
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
