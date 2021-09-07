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
    @Published var books: [[Book]] = []
    
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
            var resultBooks: [[Book]] = []
            while !displayBooks.isEmpty {
                let books = Array(displayBooks.prefix(2))
                displayBooks = Array(displayBooks.dropFirst(2))
                resultBooks.append(books)
            }
            books = resultBooks
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
