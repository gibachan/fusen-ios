//
//  SearchBookViewModel.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import Foundation

@MainActor
final class SearchBookViewModel: ObservableObject {
    private let searchPublicationsByTitleUseCase: SearchPublicationsByTitleUseCase
    private let addBookByPublicationUseCase: AddBookByPublicationUseCase

    @Published var state: State = .initial

    nonisolated init(searchPublicationsByTitleUseCase: SearchPublicationsByTitleUseCase = SearchPublicationsByTitleUseCaseImpl(),
                     addBookByPublicationUseCase: AddBookByPublicationUseCase = AddBookByPublicationUseCaseImpl()) {
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
            state = .failed
        }
    }
    
//    func onTextChange(title: String, author: String) {
//        isSaveEnabled = title.isNotEmpty
//    }
    
//    @MainActor
//    func onSave(title: String, author: String, thumbnailImage: ImageData?, collection: Collection?) async {
//    }

    enum State {
        case initial
        case loading
        case loaded(publications: [Publication])
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .failed:
                return false
            case .loading:
                return true
            }
        }
    }
}
