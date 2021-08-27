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
    
    func onSave(title: String, author: String, thumbnailImage: ImageData?, collection: Collection?) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        let publication = Publication(
            title: title,
            author: author,
            thumbnailURL: nil
        )

        state = .loading
        do {
            let id = try await bookRepository.addBook(of: publication, in: collection, for: user)
            log.d("Book is added for id: \(id.value)")
            
            if let image = thumbnailImage {
                let book = try await bookRepository.getBook(by: id, for: user)
                try await bookRepository.update(book: book, image: image, for: user)
                log.d("Thumbnail image is updated for book id: \(id.value)")
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .succeeded
                // 強制的に更新 -> Viewの再構築が発生するため注意
                NotificationCenter.default.postRefreshBookShelfAllCollection()
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
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
