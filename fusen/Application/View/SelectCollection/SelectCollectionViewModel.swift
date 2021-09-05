//
//  SelectCollectionViewModel.swift
//  SelectCollectionViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Foundation

@MainActor
final class SelectCollectionViewModel: ObservableObject {
    private let getCollectionsUseCase: GetCollectionsUseCase
    private let updateBookCollectionUseCase: UpdateBookCollectionUseCase
    
    @Published var state: State = .initial
    @Published var book: Book
    @Published var collections: [Collection] = []
    
    init(
        book: Book,
        getCollectionsUseCase: GetCollectionsUseCase = GetCollectionsUseCaseImpl(),
        updateBookCollectionUseCase: UpdateBookCollectionUseCase = UpdateBookCollectionUseCaseImpl()
    ) {
        self.book = book
        self.getCollectionsUseCase = getCollectionsUseCase
        self.updateBookCollectionUseCase = updateBookCollectionUseCase
    }
    
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
    
    func onSelect(collection: Collection) async {
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
