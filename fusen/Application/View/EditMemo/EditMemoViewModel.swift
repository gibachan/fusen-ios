//
//  EditMemoViewModel.swift
//  EditMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

final class EditMemoViewModel: ObservableObject {
    private let imageCountLimit = 1
    private let book: Book
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published var memo: Memo
    @Published var imageResults: [DocumentCameraView.ImageResult] = []
    
    init(
        book: Book,
        memo: Memo,
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.book = book
        self.memo = memo
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func onTextChange(_ text: String) {
        isSaveEnabled = !text.isEmpty
    }
    
    func onMemoImageAdd(images: [DocumentCameraView.ImageResult]) {
        imageResults = Array(images.prefix(imageCountLimit))
    }
    
    func onMemoImageDelete(image: DocumentCameraView.ImageResult) {
        imageResults = imageResults.filter { $0.id != image.id }
    }
    
    func onSave(
        text: String,
        quote: String,
        page: Int,
        imageURLs: [URL]
    ) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let memoPage: Int? = page == 0 ? nil : page
            try await memoRepository.update(memo: memo, of: book, text: text, quote: quote, page: memoPage, imageURLs: imageURLs, for: user)
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
    
    func onDelete() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            try await memoRepository.delete(memo: memo, of: book, for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .deleted
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
