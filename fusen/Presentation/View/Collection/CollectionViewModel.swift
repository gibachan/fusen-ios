//
//  CollectionViewModel.swift
//  CollectionViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import Data
import Domain
import Foundation

final class CollectionViewModel: ObservableObject {
    private let getCurrentBookSortUseCase: GetCurrentBookSortUseCase
    private let updateCurrentBookSortUseCase: UpdateCurrentBookSortUseCase
    private var getBooksByCollectionUseCase: GetBooksByCollectionUseCase
    private let deleteCollectionUseCase: DeleteCollectionUseCase

    @Published var collection: Collection
    @Published var state: State = .initial
    @Published var pager: Pager<Book> = .empty
    @Published var sortedBy: BookSort

    init(
        collection: Collection,
        getCurrentBookSortUseCase: GetCurrentBookSortUseCase = GetCurrentBookSortUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl()),
        updateCurrentBookSortUseCase: UpdateCurrentBookSortUseCase = UpdateCurrentBookSortUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl()),
        deleteCollectionUseCase: DeleteCollectionUseCase = DeleteCollectionUseCaseImpl(accountService: AccountService.shared, collectionRepository: CollectionRepositoryImpl())
    ) {
        self.getCurrentBookSortUseCase = getCurrentBookSortUseCase
        self.updateCurrentBookSortUseCase = updateCurrentBookSortUseCase
        let bookSort = getCurrentBookSortUseCase.invoke()
        let sortedBy = bookSort
        self.sortedBy = sortedBy
        self.collection = collection
        self.getBooksByCollectionUseCase = GetBooksByCollectionUseCaseImpl(collection: collection, sortedBy: bookSort, accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
        self.deleteCollectionUseCase = deleteCollectionUseCase
    }

    @MainActor
    func onAppear() async {
        guard !state.isInProgress else { return }

        state = .loading
        do {
            let pager = try await getBooksByCollectionUseCase.invoke(forceRefresh: false)
            log.d("finished=\(pager.finished)")
            self.state = .succeeded
            self.pager = pager
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
            NotificationCenter.default.postError(message: .network)
        }
    }

    func onRefresh() async {
        await refresh()
    }

    @MainActor
    func onItemApper(of book: Book) async {
        guard case .succeeded = state, !pager.finished else { return }
        guard let lastBook = pager.data.last else { return }

        if book.id == lastBook.id {
            state = .loadingNext
            do {
                let pager = try await getBooksByCollectionUseCase.invokeNext()
                log.d("finished=\(pager.finished)")
                self.state = .succeeded
                self.pager = pager
            } catch {
                log.e(error.localizedDescription)
                self.state = .failed
            }
        }
    }

    func onSort(_ sortedBy: BookSort) async {
        updateCurrentBookSortUseCase.invoke(bookSort: sortedBy)
        self.sortedBy = sortedBy
        self.getBooksByCollectionUseCase = GetBooksByCollectionUseCaseImpl(collection: collection, sortedBy: sortedBy, accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
        await refresh()
    }

    @MainActor
    func onDelete() async {
        guard !state.isInProgress else { return }

        state = .loading
        do {
            try await deleteCollectionUseCase.invoke(collection: collection)
            state = .deleted
        } catch {
            print(error.localizedDescription)
            state = .failed
            NotificationCenter.default.postError(message: .deleteCollection)
        }
    }

    @MainActor
    private func refresh() async {
        guard !state.isInProgress else { return }

        state = .refreshing
        do {
            let pager = try await getBooksByCollectionUseCase.invoke(forceRefresh: true)
            log.d("finished=\(pager.finished)")
            self.state = .succeeded
            self.pager = pager
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
        }
    }

    enum State {
        case initial
        case loading
        case loadingNext
        case refreshing
        case succeeded
        case deleted
        case failed

        var isInProgress: Bool {
            switch self {
            case .initial, .succeeded, .deleted, .failed:
                return false
            case .loading, .loadingNext, .refreshing:
                return true
            }
        }
    }
}
