//
//  LatestMemoItemModel.swift
//  LatestMemoItemModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Data
import Domain
import Foundation

final class LatestMemoItemModel: ObservableObject {
    private let getBookByIdUseCase: GetBookByIdUseCase

    @Published var memo: Memo
    @Published var book: Book?
    @Published var state: State = .initial

    init(
        memo: Memo,
        getBookByIdUseCase: GetBookByIdUseCase = GetBookByIdUseCaseImpl(accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
    ) {
        self.memo = memo
        self.getBookByIdUseCase = getBookByIdUseCase
    }

    @MainActor
    func onAppear() async {
        guard !state.isInProgress else { return }

        state = .loading
        do {
            let book = try await getBookByIdUseCase.invoke(id: memo.bookId)
            self.state = .succeeded
            self.book = book
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
        }
    }

    enum State {
        case initial
        case loading
        case succeeded
        case failed

        var isInProgress: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }
}
