//
//  AddMemoViewModel.swift
//  AddMemoViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Data
import Domain
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

    var isLoading: Bool {
        switch state {
        case .loading:
            return true
        default:
            return false
        }
    }

    init(
        book: Book,
        getUserActionHistoryUseCase: GetUserActionHistoryUseCase = GetUserActionHistoryUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl()),
        addMemoUseCase: AddMemoUseCase = AddMemoUseCaseImpl(accountService: AccountService.shared, memoRepository: MemoRepositoryImpl()),
        readBookUseCase: ReadBookUseCase = ReadBookUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl()),
        recognizeTextUseCase: RecognizeTextUseCase = RecognizeTextUseCaseImpl(appConfigRepository: AppConfigRepositoryImpl(), visionTextRecognizeService: VisionTextRecognizeService()),
        reviewAppUseCase: ReviewAppUseCase = ReviewAppUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl())
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
        let userActionHistory = getUserActionHistoryUseCase.invoke()
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
            readBookUseCase.invoke(book: book, page: page)
            log.d("Memo is added for id: \(id.value)")

            // Request app review
            var showAppReview = false
            let userActionHistory = getUserActionHistoryUseCase.invoke()
            if userActionHistory.reviewedVersion == nil {
                showAppReview = true
                reviewAppUseCase.invoke(version: Bundle.main.shortVersion)
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
