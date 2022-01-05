//
//  BookShelfFavoriteSectionModel.swift
//  BookShelfFavoriteSectionModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/22.
//

import Foundation

final class BookShelfFavoriteSectionModel: ObservableObject {
    private static let maxDiplayBookCount = 6
    private let getFavoriteBooksUseCase: GetFavoriteBooksUseCase
    
    @Published var state: State = .initial
    @Published var bookColumns: [BookShelfColumn] = []
    
    init(
        getFavoriteBooksUseCase: GetFavoriteBooksUseCase = GetFavoriteBooksUseCaseImpl()
    ) {
        self.getFavoriteBooksUseCase = getFavoriteBooksUseCase
    }
    
    @MainActor
    func onAppear() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await getFavoriteBooksUseCase.invoke(forceRefresh: true)
            state = .succeeded
            
            var displayBooks = Array(pager.data.prefix(Self.maxDiplayBookCount))
            var resultColumns: [BookShelfColumn] = []
            while !displayBooks.isEmpty {
                let books = Array(displayBooks.prefix(2))
                let column = BookShelfColumn(id: UUID().uuidString, books: books)
                displayBooks = Array(displayBooks.dropFirst(2))
                resultColumns.append(column)
            }
            bookColumns = resultColumns
        } catch {
            log.e(error.localizedDescription)
            state = .failed
        }
    }
    
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
