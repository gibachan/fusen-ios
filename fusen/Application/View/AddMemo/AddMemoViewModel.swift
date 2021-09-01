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
    private let onDeviceTextRecognizeService: TextRecognizeServiceProtocol
    private let visionTextRecognizeService: TextRecognizeServiceProtocol
    private let appConfigRepository: AppConfigRepository
    private let memoRepository: MemoRepository
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published private var memoImage: ImageData?
    @Published var recognizedQuote = ""
    
    init(
        book: Book,
        accountService: AccountServiceProtocol = AccountService.shared,
        onDeviceTextRecognizeService: TextRecognizeServiceProtocol = OnDeviceTextRecognizeService(),
        visionTextRecognizeService: TextRecognizeServiceProtocol = VisionTextRecognizeService(),
        appConfigRepository: AppConfigRepository = AppConfigRepositoryImpl(),
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.book = book
        self.accountService = accountService
        self.onDeviceTextRecognizeService = onDeviceTextRecognizeService
        self.visionTextRecognizeService = visionTextRecognizeService
        self.appConfigRepository = appConfigRepository
        self.memoRepository = memoRepository
    }
    
    func onTextChange(_ text: String) {
        isSaveEnabled = !text.isEmpty
    }
    
    func onQuoteImageTaken(imageData: ImageData) async {
        guard !state.isInProgress else { return }
        guard let image = imageData.uiImage else { return }
        
        state = .loading
        
        let config = await appConfigRepository.get()
        let textRecognizeService: TextRecognizeServiceProtocol
        if config.isVisionAPIUse {
            log.d("Use VisionTextRecognizeService")
            textRecognizeService = visionTextRecognizeService
        } else {
            log.d("Use OnDeviceTextRecognizeService")
            textRecognizeService = onDeviceTextRecognizeService
        }
        let text = await textRecognizeService.text(from: image)
        log.d("recognized=\(text)")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.state = .recognizedQuote
            self.recognizedQuote = text
        }
    }
    
    func onSave(
        text: String,
        quote: String,
        page: Int,
        image: ImageData?
    ) async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let memoPage: Int? = page == 0 ? nil : page
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
        case recognizedQuote
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
