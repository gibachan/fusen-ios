//
//  EditBookViewModel.swift
//  EditBookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import Foundation

final class EditViewModel: ObservableObject {
    private let updateBookUseCase: UpdateBookUseCase

    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published var imageURL: URL?
    @Published var book: Book

    init(
        book: Book,
        updateBookUseCase: UpdateBookUseCase = UpdateBookUseCaseImpl()
    ) {
        self.book = book
        self.updateBookUseCase = updateBookUseCase
    }
    
    @MainActor
    func onAppear() {
        imageURL = book.imageURL
    }
    
    @MainActor
    func onTextChange(title: String, author: String, description: String) {
        isSaveEnabled = book.title != title || book.author != author || book.description != description
    }
    
    @MainActor
    func onSave(title: String, author: String, description: String) async {
        guard !state.isInProgress else { return }

        state = .loading
        do {
            try await updateBookUseCase.invoke(book: book, title: title, author: author, description: description)
            self.state = .succeeded
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
            NotificationCenter.default.postError(message: .editBook)
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
