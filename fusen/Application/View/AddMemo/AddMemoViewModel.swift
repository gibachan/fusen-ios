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
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    
    init(
        book: Book,
        accountService: AccountServiceProtocol = AccountService.shared
    ) {
        self.book = book
        self.accountService = accountService
    }
    
    func onTextChange(_ text: String) {
        isSaveEnabled = !text.isEmpty
    }
    
    func onSave() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isLoading else { return }
        
        state = .loading
        do {
            // TODO: Save memo
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
