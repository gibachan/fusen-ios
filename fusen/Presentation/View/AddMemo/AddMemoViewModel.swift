//
//  AddMemoViewModel.swift
//  AddMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

final class AddMemoViewModel: NSObject, ObservableObject {
    private let imageCountLimit = 1
    private let getUserActionHistoryUseCase: GetUserActionHistoryUseCase
    private let addMemoUseCase: AddMemoUseCase
    private let readBookUseCase: ReadBookUseCase
    private let recognizeTextUseCase: RecognizeTextUseCase
    private let reviewAppUseCase: ReviewAppUseCase
    
    @Published var book: Book
    @Published var initialPage: Int = 0
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published private var memoImage: ImageData?
    @Published var recognizedQuote = ""
    
    init(
        book: Book,
        getUserActionHistoryUseCase: GetUserActionHistoryUseCase = GetUserActionHistoryUseCaseImpl(),
        addMemoUseCase: AddMemoUseCase = AddMemoUseCaseImpl(),
        readBookUseCase: ReadBookUseCase = ReadBookUseCaseImpl(),
        recognizeTextUseCase: RecognizeTextUseCase = RecognizeTextUseCaseImpl(),
        reviewAppUseCase: ReviewAppUseCase = ReviewAppUseCaseImpl()
    ) {
        self.book = book
        self.getUserActionHistoryUseCase = getUserActionHistoryUseCase
        self.addMemoUseCase = addMemoUseCase
        self.readBookUseCase = readBookUseCase
        self.recognizeTextUseCase = recognizeTextUseCase
        self.reviewAppUseCase = reviewAppUseCase
    }
    
    @MainActor
    func onAppear() async {
        let userActionHistory = await getUserActionHistoryUseCase.invoke()
        if let page = userActionHistory.readBookPages[book.id] {
            initialPage = page
        }
    }
    
    @MainActor
    func onTextChange(text: String, quote: String) {
        isSaveEnabled = text.isNotEmpty || quote.isNotEmpty
    }
    
    @MainActor
    func onQuoteImageTaken(imageData: ImageData) async {
        guard !state.isInProgress else { return }
        
        state = .loading
        let text = await recognizeTextUseCase.invoke(imageData: imageData)
        log.d("recognized=\(text)")
        state = .recognizedQuote
        recognizedQuote = text
    }
    
    @MainActor
    func onSave(
        text: String,
        quote: String,
        page: Int,
        image: ImageData?
    ) async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let id = try await addMemoUseCase.invoke(book: book, text: text, quote: quote, page: page, image: image)
            await readBookUseCase.invoke(book: book, page: page)
            log.d("Memo is added for id: \(id.value)")
            
            // Request app review
            var showAppReview = false
            let userActionHistory = await getUserActionHistoryUseCase.invoke()
            if userActionHistory.reviewedVersion == nil {
                showAppReview = true
                await reviewAppUseCase.invoke(version: Bundle.main.shortVersion)
            }
            state = .succeeded(showAppReview: showAppReview)
        } catch {
            log.e(error.localizedDescription)
            state = .failed
        }
    }
    
    enum State {
        case initial
        case loading
        case succeeded(showAppReview: Bool)
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
