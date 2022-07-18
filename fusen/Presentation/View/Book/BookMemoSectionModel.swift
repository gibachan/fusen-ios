//
//  BookMemoSectionModel.swift
//  BookMemoSectionModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/26.
//

import Foundation

final class BookMemoSectionModel: ObservableObject {
    private let bookId: ID<Book>
    private let getCurrentMemoSortUseCase: GetCurrentMemoSortUseCase
    private let updateCurrentMemoSortUseCase: UpdateCurrentMemoSortUseCase
    private var getMemosUseCase: GetMemosUseCase
    
    @Published var state: State = .initial
    @Published var memoPager: Pager<Memo> = .empty
    @Published var sortedBy: MemoSort
    
    init(
        bookId: ID<Book>
    ) {
        self.bookId = bookId
        self.getCurrentMemoSortUseCase = GetCurrentMemoSortUseCaseImpl()
        self.updateCurrentMemoSortUseCase = UpdateCurrentMemoSortUseCaseImpl()
        let memoSort = getCurrentMemoSortUseCase.invoke()
        self.sortedBy = memoSort
        self.getMemosUseCase = GetMemosUseCaseImpl(bookId: bookId, sortedBy: memoSort)
    }
    
    func onAppear() async {
        await load()
    }
    
    func onRefresh() async {
        await load()
    }
    
    @MainActor
    func onItemApper(of memo: Memo) async {
        guard case .loaded = state, !memoPager.finished else { return }
        guard let lastMemo = memoPager.data.last else { return }
        
        if memo.id == lastMemo.id {
            //            state = .loadingNext
            do {
                let pager = try await getMemosUseCase.invokeNext()
                log.d("finished=\(pager.finished)")
                memoPager = pager
            } catch {
                log.e(error.localizedDescription)
                state = .failed
            }
        }
    }
    
    @MainActor
    func onSort(_ sortedBy: MemoSort) async {
        updateCurrentMemoSortUseCase.invoke(memoSort: sortedBy)
        self.sortedBy = sortedBy
        self.getMemosUseCase = GetMemosUseCaseImpl(bookId: bookId, sortedBy: sortedBy)
        await load()
    }
    
    @MainActor
    private func load() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let memoPager = try await getMemosUseCase.invoke(forceRefresh: false)
            self.memoPager = memoPager
            self.state = .loaded(memos: memoPager.data)
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
            NotificationCenter.default.postError(message: .getMemo)
        }
    }
    
    enum State {
        case initial
        case loaded(memos: [Memo])
        case loading
        case loadingNext
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .failed:
                return false
            case .loading, .loadingNext:
                return true
            }
        }
    }
}
