//
//  MemoListViewModel.swift
//  MemoListViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import Data
import Domain
import Foundation

final class MemoListViewModel: ObservableObject {
    private let getAllMemosUseCase: GetAllMemosUseCase

    @Published var state: State = .initial
    @Published var pager: Pager<Memo> = .empty

    init(
        getAllMemosUseCase: GetAllMemosUseCase = GetAllMemosUseCaseImpl(accountService: AccountService.shared, memoRepository: MemoRepositoryImpl())
    ) {
        self.getAllMemosUseCase = getAllMemosUseCase
    }

    @MainActor
    func onAppear() async {
        guard !state.isInProgress else { return }

        state = .loading
        do {
            let pager = try await getAllMemosUseCase.invoke(forceRefresh: false)
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
            let pager = try await getAllMemosUseCase.invoke(forceRefresh: true)
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
    func onItemApper(of memo: Memo) async {
        guard case .succeeded = state, !pager.finished else { return }
        guard let lastMemo = pager.data.last else { return }

        if memo.id == lastMemo.id {
            state = .loadingNext
            do {
                let pager = try await getAllMemosUseCase.invokeNext()
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
