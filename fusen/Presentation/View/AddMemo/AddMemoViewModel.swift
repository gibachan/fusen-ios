//
//  AddMemoViewModel.swift
//  AddMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Foundation

@MainActor
final class AddMemoViewModel: NSObject, ObservableObject {
    private let imageCountLimit = 1
    private let book: Book
    private let addMemoUseCase: AddMemoUseCase
    private let recognizeTextUseCase: RecognizeTextUseCase
    
    @Published var isSaveEnabled = false
    @Published var state: State = .initial
    @Published private var memoImage: ImageData?
    @Published var recognizedQuote = ""
    
    init(
        book: Book,
        addMemoUseCase: AddMemoUseCase = AddMemoUseCaseImpl(),
        recognizeTextUseCase: RecognizeTextUseCase = RecognizeTextUseCaseImpl()
    ) {
        self.book = book
        self.addMemoUseCase = addMemoUseCase
        self.recognizeTextUseCase = recognizeTextUseCase
    }
    
    func onTextChange(text: String, quote: String) {
        isSaveEnabled = text.isNotEmpty || quote.isNotEmpty
    }
    
    func onQuoteImageTaken(imageData: ImageData) async {
        guard !state.isInProgress else { return }
        
        state = .loading
        let text = await recognizeTextUseCase.invoke(imageData: imageData)
        log.d("recognized=\(text)")
        state = .recognizedQuote
        recognizedQuote = text
    }
    
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
            log.d("Memo is added for id: \(id.value)")
            state = .succeeded
        } catch {
            log.e(error.localizedDescription)
            state = .failed
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