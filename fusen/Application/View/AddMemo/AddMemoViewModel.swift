//
//  AddMemoViewModel.swift
//  AddMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

final class AddMemoViewModel: NSObject, ObservableObject {
    private let imageCountLimit = 1
    private let book: Book
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published var imageResults: [DocumentCameraView.ImageResult] = []
    
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
        guard !state.isLoading else { return }
        
        state = .loading
        do {
            let memoPage: Int? = page == 0 ? nil : page
            let image: MemoImage? = imageResults
                .compactMap { MemoImage(uiImage: $0.image) }
                .first
            let id = try await memoRepository.addMemo(of: book, text: text, quote: quote, page: memoPage, image: image, for: user)
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
