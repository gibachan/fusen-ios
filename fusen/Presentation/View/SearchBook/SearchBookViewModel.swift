//
//  SearchBookViewModel.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import Foundation

@MainActor
final class SearchBookViewModel: ObservableObject {
    private let collection: Collection?
    private let searchPublicationsByTitleUseCase: SearchPublicationsByTitleUseCase
    private let addBookByPublicationUseCase: AddBookByPublicationUseCase

    @Published var state: State = .initial
    @Published var selectedPublication: Publication?
    
    nonisolated init(collection: Collection?,
                     searchPublicationsByTitleUseCase: SearchPublicationsByTitleUseCase = SearchPublicationsByTitleUseCaseImpl(),
                     addBookByPublicationUseCase: AddBookByPublicationUseCase = AddBookByPublicationUseCaseImpl()) {
        self.collection = collection
        self.searchPublicationsByTitleUseCase = searchPublicationsByTitleUseCase
        self.addBookByPublicationUseCase = addBookByPublicationUseCase
    }
    
    func onSearch(title: String) async {
        guard !state.isInProgress else { return }

        state = .loading
        do {
            let publications = try await searchPublicationsByTitleUseCase.invoke(withTitle: title)
            state = .loaded(publications: publications)
        } catch {
            log.e(error.localizedDescription)
            state = .loadFailed
        }
    }
    
    func onSelect(publication: Publication) {
        selectedPublication = publication
    }
    
    func onAdd() async {
        guard let publication = selectedPublication else { return }
        guard !state.isInProgress else { return }

        state = .loading
        do {
            let id = try await addBookByPublicationUseCase.invoke(publication: publication, collection: collection)
            log.d("Book is added for id: \(id.value)")
            // 強制的に更新 -> Viewの再構築が発生するため注意
            NotificationCenter.default.postRefreshBookShelfAllCollection()
            state = .added
        } catch {
            log.e(error.localizedDescription)
            state = .addFailed
        }
    }
    
    enum State {
        case initial
        case loading
        case loaded(publications: [Publication])
        case added
        case loadFailed
        case addFailed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .added, .loadFailed, .addFailed:
                return false
            case .loading:
                return true
            }
        }
    }
}