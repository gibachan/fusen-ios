//
//  AddBookViewModel.swift
//  AddBookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import Foundation

final class AddBookViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    @Published var isSaveEnabled = false
    @Published var state: State = .initial

    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onTextChange(title: String, author: String) {
        isSaveEnabled = !title.isEmpty
    }
    
    func onSave(title: String, author: String) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        let publication = Publication(
            title: title,
            author: author,
            thumbnailURL: nil
        )

        state = .loading
        do {
            let id = try await bookRepository.addBook(of: publication, in: nil, for: user)
            log.d("Book is added for id: \(id.value)")
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                NotificationCenter.default.postRefreshBookShelf()
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
        
        var isInProgress: Bool {
            switch self {
            case .initial, .succeeded, .failed:
                return false
            case .loading:
                return true
            }
        }
    }
}
