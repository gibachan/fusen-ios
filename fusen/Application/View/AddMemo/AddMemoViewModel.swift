//
//  AddMemoViewModel.swift
//  AddMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

final class AddMemoViewModel: ObservableObject {
    private let book: Book
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    
    init(
        book: Book,
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.book = book
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func onTextChange(_ text: String) {
        isSaveEnabled = !text.isEmpty
    }
    
    func onSave(
        text: String,
        quote: String,
        page: Int,
        imageURLs: [URL]
    ) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isLoading else { return }
        
        state = .loading
        do {
            let memoPage: Int? = page == 0 ? nil : page
            let id = try await memoRepository.addMemo(of: book, text: text, quote: quote, page: memoPage, imageURLs: imageURLs, for: user)
            log.d("Memo is added for id: \(id.value)")
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
            }
        } catch {
            // FIXME: error handling
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case failed
        
        var isLoading: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }
}