//
//  BookListViewModel.swift
//  BookListViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Data
import Domain
import Foundation

final class BookListViewModel: ObservableObject {
    private let getCurrentBookSortUseCase: GetCurrentBookSortUseCase
    private let updateCurrentBookSortUseCase: UpdateCurrentBookSortUseCase
    private var getAllBooksUseCase: GetAllBooksUseCase

    @Published var state: State = .initial
    @Published var pager: Pager<Book> = .empty
    @Published var sortedBy: BookSort
    
    init(getCurrentBookSortUseCase: GetCurrentBookSortUseCase = GetCurrentBookSortUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl()),
         updateCurrentBookSortUseCase: UpdateCurrentBookSortUseCase = UpdateCurrentBookSortUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl())) {
        self.getCurrentBookSortUseCase = getCurrentBookSortUseCase
        self.updateCurrentBookSortUseCase = updateCurrentBookSortUseCase
        let bookSort = getCurrentBookSortUseCase.invoke()
        let sortedBy = bookSort
        self.sortedBy = sortedBy
        getAllBooksUseCase = GetAllBooksUseCaseImpl(sortedBy: sortedBy, accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
    }

    @MainActor
    func onAppear() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await getAllBooksUseCase.invoke(forceRefresh: false)
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
                let pager = try await getAllBooksUseCase.invokeNext()
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
    
    func onSort(_ sortedBy: BookSort) async {
        updateCurrentBookSortUseCase.invoke(bookSort: sortedBy)
        self.sortedBy = sortedBy
        self.getAllBooksUseCase = GetAllBooksUseCaseImpl(sortedBy: sortedBy, accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
        await refresh()
    }
    
    @MainActor
    private func refresh() async {
        guard !state.isInProgress else { return }
        
        state = .refreshing
        do {
            let pager = try await getAllBooksUseCase.invoke(forceRefresh: true)
            log.d("finished=\(pager.finished)")
            self.state = .succeeded
            self.pager = pager
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
            NotificationCenter.default.postError(message: .network)
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
