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
    private let textRecognizeService: TextRecognizeServiceProtocol
    private let memoRepository: MemoRepository
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published var imageResults: [DocumentCameraView.ImageResult] = []
    @Published var recognizedQuote = ""
    
    init(
        book: Book,
        accountService: AccountServiceProtocol = AccountService.shared,
        textRecognizeService: TextRecognizeServiceProtocol = TextRecognizeService(),
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.book = book
        self.accountService = accountService
        self.textRecognizeService = textRecognizeService
        self.memoRepository = memoRepository
    }
    
    func onTextChange(_ text: String) {
        isSaveEnabled = !text.isEmpty
    }
    
    func onQuoteImageTaken(images: [DocumentCameraView.ImageResult]) async {
        guard let image = images.first else { return }
        let text = await textRecognizeService.text(from: image.image)
        log.d("recognized=\(text)")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recognizedQuote = text
        }
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
            let image: ImageData? = imageResults
                .compactMap { ImageData(type: .memo, uiImage: $0.image) }
                .first
            let id = try await memoRepository.addMemo(of: book, text: text, quote: quote, page: memoPage, image: image, for: user)
            log.d("Memo is added for id: \(id.value)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .succeeded
            }
        } catch {
            log.e(error.localizedDescription)
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
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }
}
