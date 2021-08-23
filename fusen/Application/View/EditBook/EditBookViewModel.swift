//
//  EditBookViewModel.swift
//  EditBookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import Foundation

final class EditViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published var book: Book

    init(
        book: Book,
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.book = book
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onTextChange(title: String, author: String, description: String) {
        isSaveEnabled = book.title != title || book.author != author || book.description != description
    }
    
//    func onAppear() async {
//        guard let user = accountService.currentUser else { return }
//        guard !state.isInProgress else { return }
//
//        state = .loading
//        do {
//            let pager = try await bookRepository.getAllBooks(for: user)
//            log.d("finished=\(pager.finished)")
//            DispatchQueue.main.async { [weak self] in
//                self?.textCountText = "xx冊の書籍"
//                self?.state = .succeeded
//                self?.pager = pager
//            }
//        } catch {
//            log.e(error.localizedDescription)
//            DispatchQueue.main.async { [weak self] in
//                self?.state = .failed
//            }
//        }
//    }
    
    func onUpdate(title: String, author: String, description: String) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }

        state = .loading
        do {
            try await bookRepository.update(book: book, title: title, author: author, description: description, for: user)
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
