//
//  BookShelfAllSectionModel.swift
//  BookShelfAllSectionModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/22.
//

import Foundation

@MainActor
final class BookShelfAllSectionModel: ObservableObject {
    private static let maxDiplayBookCount = 6
    private let getAllBooksUseCase: GetAllBooksUseCase
    
    @Published var state: State = .initial
    @Published var bookColumns: [BookShelfColumn] = []
    
    init(
        getAllBooksUseCase: GetAllBooksUseCase = GetAllBooksUseCaseImpl(sortedBy: .default)
    ) {
        self.getAllBooksUseCase = getAllBooksUseCase
    }
    
    func onAppear() async {
        await getBooks()
    }
    
    func onRefresh() async {
        await getBooks()
    }
    
    private func getBooks() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await getAllBooksUseCase.invoke(forceRefresh: true)
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
