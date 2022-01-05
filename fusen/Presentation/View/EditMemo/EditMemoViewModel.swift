//
//  EditMemoViewModel.swift
//  EditMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

final class EditMemoViewModel: ObservableObject {
    private let updateMemoUseCase: UpdateMemoUseCase
    private let deleteMemoUseCase: DeleteMemoUseCase
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published var memo: Memo
    @Published var memoImageURL: URL?
    
    init(
        memo: Memo,
        updateMemoUseCase: UpdateMemoUseCase = UpdateMemoUseCaseImpl(),
        deleteMemoUseCase: DeleteMemoUseCase = DeleteMemoUseCaseImpl()
    ) {
        self.updateMemoUseCase = updateMemoUseCase
        self.deleteMemoUseCase = deleteMemoUseCase

        self.memo = memo
        self.memoImageURL = memo.imageURLs.first
        self.isSaveEnabled = memo.text.isNotEmpty || memo.quote.isNotEmpty
    }
    
    @MainActor
    func onTextChange(text: String, quote: String) {
        isSaveEnabled = text.isNotEmpty || quote.isNotEmpty
    }
    
    @MainActor
    func onSave(
        text: String,
        quote: String,
        page: Int
    ) async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await updateMemoUseCase.invoke(memo: memo, text: text, quote: quote, page: page, imageURLs: memo.imageURLs)
            state = .succeeded
        } catch {
            log.e(error.localizedDescription)
            state = .failed
            NotificationCenter.default.postError(message: .editMemo)
        }
    }
    
    @MainActor
    func onDelete() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await deleteMemoUseCase.invoke(memo: memo)
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
