//
//  EditMemoViewModel.swift
//  EditMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

@MainActor
final class EditMemoViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published var memo: Memo
    @Published var memoImageURL: URL?
    
    init(
        memo: Memo,
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.accountService = accountService
        self.memoRepository = memoRepository

        self.memo = memo
        self.memoImageURL = memo.imageURLs.first
        self.isSaveEnabled = !memo.text.isEmpty
    }
    
    func onTextChange(text: String, quote: String) {
        isSaveEnabled = text.isNotEmpty || quote.isNotEmpty
    }
    
    func onSave(
        text: String,
        quote: String,
        page: Int
    ) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let memoPage: Int? = page == 0 ? nil : page
            try await memoRepository.update(memo: memo, text: text, quote: quote, page: memoPage, imageURLs: memo.imageURLs, for: user)
            state = .succeeded
        } catch {
            log.e(error.localizedDescription)
            state = .failed
            NotificationCenter.default.postError(message: .editMemo)
        }
    }
    
    func onDelete() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await memoRepository.delete(memo: memo, for: user)
            state = .deleted
        } catch {
            log.e(error.localizedDescription)
            state = .failed
            NotificationCenter.default.postError(message: .deleteMemo)
        }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case deleted
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
