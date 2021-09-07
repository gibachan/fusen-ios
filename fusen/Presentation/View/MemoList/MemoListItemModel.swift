//
//  MemoListItemModel.swift
//  MemoListItemModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import Foundation

@MainActor
final class MemoListItemModel: ObservableObject {
    private let memo: Memo
    private let getBookByIdUseCase: GetBookByIdUseCase
    private var state: State = .initial

    @Published var bookTitle: String = ""
    
    init(
        memo: Memo,
        getBookByIdUseCase: GetBookByIdUseCase = GetBookByIdUseCaseImpl()
    ) {
        self.memo = memo
        self.getBookByIdUseCase = getBookByIdUseCase
    }
    
    func onAppear() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let book = try await getBookByIdUseCase.invoke(id: memo.bookId)
            state = .loaded(book: book)
            bookTitle = book.title
        } catch {
            log.e(error.localizedDescription)
            state = .failed
        }
    }
    
    enum State {
        case initial
        case loading
        case loaded(book: Book)
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
