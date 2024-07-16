//
//  SelectCollectionViewModel.swift
//  SelectCollectionViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Data
import Domain
import Foundation

final class SelectCollectionViewModel: ObservableObject {
    private let getCollectionsUseCase: GetCollectionsUseCase
    private let updateBookCollectionUseCase: UpdateBookCollectionUseCase
    
    @Published var state: State = .initial
    @Published var book: Book
    @Published var collections: [Domain.Collection] = []
    
    init(
        book: Book,
        getCollectionsUseCase: GetCollectionsUseCase = GetCollectionsUseCaseImpl(accountService: AccountService.shared, collectionRepository: CollectionRepositoryImpl()),
        updateBookCollectionUseCase: UpdateBookCollectionUseCase = UpdateBookCollectionUseCaseImpl(accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
    ) {
        self.book = book
        self.getCollectionsUseCase = getCollectionsUseCase
        self.updateBookCollectionUseCase = updateBookCollectionUseCase
    }
    
    @MainActor
    func onAppear() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let collections = try await getCollectionsUseCase.invoke()
            self.state = .loaded
            self.collections = collections
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
            NotificationCenter.default.postError(message: .network)
        }
    }
    
    @MainActor
    func onSelect(collection: Domain.Collection) async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await updateBookCollectionUseCase.invoke(book: book, collection: collection)
            state = .updated
        } catch {
            log.e(error.localizedDescription)
            state = .failed
            NotificationCenter.default.postError(message: .selectCollection)
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
