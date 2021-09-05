//
//  BookShelfCollectionSectionModel.swift
//  BookShelfCollectionSectionModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

@MainActor
final class BookShelfCollectionSectionModel: ObservableObject {
    private static let maxDiplayBookCount = 6
    private let getBooksByCollectionUseCase: GetBooksByCollectionUseCase
    
    @Published var state: State = .initial
    @Published var collection: Collection
    @Published var books: [[Book]] = []
    
    init(
        collection: Collection
    ) {
        self.collection = collection
        self.getBooksByCollectionUseCase = GetBooksByCollectionUseCaseImpl(collection: collection)
    }
    
    func onAppear() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await getBooksByCollectionUseCase.invoke(forceRefresh: true)
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
