//
//  MemoListViewModel.swift
//  MemoListViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import Foundation

final class MemoListViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository

    @Published var state: State = .initial
    @Published var pager: Pager<Memo> = .empty
    @Published var textCountText = ""
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository
    }

    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await memoRepository.getAllMemos(for: user)
            log.d("finished=\(pager.finished)")
            DispatchQueue.main.async { [weak self] in
                self?.textCountText = "xx冊の書籍"
                self?.state = .succeeded
                self?.pager = pager
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    func onRefresh() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .refreshing
        do {
            let pager = try await memoRepository.getAllMemos(for: user, forceRefresh: true)
            log.d("finished=\(pager.finished)")
            DispatchQueue.main.async { [weak self] in
                self?.textCountText = "xx件のメモ"
                self?.state = .succeeded
                self?.pager = pager
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    func onItemApper(of memo: Memo) async {
        guard case .succeeded = state, !pager.finished else { return }
        guard let user = accountService.currentUser else { return }
        guard let lastMemo = pager.data.last else { return }

        if memo.id == lastMemo.id {
            state = .loadingNext
            do {
                let pager = try await memoRepository.getAllMemosNext(for: user)
                log.d("finished=\(pager.finished)")
                DispatchQueue.main.async { [weak self] in
                    self?.state = .succeeded
                    self?.pager = pager
                }
            } catch {
                log.e(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.state = .failed
                }
            }
        }
    }
    
    // associated valueに変更があってもSwiftUIは検知してくれない
    // (state自体が変更されない限りViewが更新されない）
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