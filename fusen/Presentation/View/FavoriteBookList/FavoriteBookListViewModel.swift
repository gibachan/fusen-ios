//
//  FavoriteBookListViewModel.swift
//  FavoriteBookListViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import Data
import Domain
import Foundation

final class FavoriteBookListViewModel: ObservableObject {
    private let getFavoriteBooksUseCase: GetFavoriteBooksUseCase

    @Published var state: State = .initial
    @Published var pager: Pager<Book> = .empty

    init(
        getFavoriteBooksUseCase: GetFavoriteBooksUseCase = GetFavoriteBooksUseCaseImpl(accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
    ) {
        self.getFavoriteBooksUseCase = getFavoriteBooksUseCase
    }

    @MainActor
    func onAppear() async {
        guard !state.isInProgress else { return }

        state = .loading
        do {
            let pager = try await getFavoriteBooksUseCase.invoke(forceRefresh: false)
            log.d("finished=\(pager.finished)")
            self.state = .succeeded
            self.pager = pager
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
            NotificationCenter.default.postError(message: .network)
        }
    }

    @MainActor
    func onRefresh() async {
        guard !state.isInProgress else { return }

        state = .refreshing
        do {
            let pager = try await getFavoriteBooksUseCase.invoke(forceRefresh: true)
            log.d("finished=\(pager.finished)")
            self.state = .succeeded
            self.pager = pager
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
            NotificationCenter.default.postError(message: .network)
        }
    }

    @MainActor
    func onItemApper(of book: Book) async {
        guard case .succeeded = state, !pager.finished else { return }
        guard let lastBook = pager.data.last else { return }

        if book.id == lastBook.id {
            state = .loadingNext
            do {
                let pager = try await getFavoriteBooksUseCase.invokeNext()
                log.d("finished=\(pager.finished)")
                self.state = .succeeded
                self.pager = pager
            } catch {
                log.e(error.localizedDescription)
                self.state = .failed
                NotificationCenter.default.postError(message: .network)
            }
        }
    }

    enum State {
        case initial
        case loading
        case loadingNext
        case refreshing
        case succeeded
        case failed

        var isInProgress: Bool {
            switch self {
            case .initial, .succeeded, .failed:
                return false
            case .loading, .loadingNext, .refreshing:
                return true
            }
        }
    }
}
