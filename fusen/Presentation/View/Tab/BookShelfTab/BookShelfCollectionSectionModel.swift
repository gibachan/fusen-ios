//
//  BookShelfCollectionSectionModel.swift
//  BookShelfCollectionSectionModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Domain
import Foundation

final class BookShelfCollectionSectionModel: ObservableObject {
    private static let maxDiplayBookCount = 6
    private let getBooksByCollectionUseCase: GetBooksByCollectionUseCase
    
    @Published var state: State = .initial
    @Published var collection: Domain.Collection
    @Published var bookColumns: [BookShelfColumn] = []
    
    init(
        collection: Domain.Collection
    ) {
        self.collection = collection
        self.getBooksByCollectionUseCase = GetBooksByCollectionUseCaseImpl(collection: collection, sortedBy: .default, accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
    }
    
    @MainActor
    func onAppear() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await getBooksByCollectionUseCase.invoke(forceRefresh: true)
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
