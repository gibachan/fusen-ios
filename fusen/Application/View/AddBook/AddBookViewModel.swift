//
//  AddBookViewModel.swift
//  AddBookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import Foundation

@MainActor
final class AddBookViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol
    private let bookRepository: BookRepository

    @Published var isSaveEnabled = false
    @Published var state: State = .initial

    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        analyticsService: AnalyticsServiceProtocol = AnalyticsService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.analyticsService = analyticsService
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
            let id = try await bookRepository.addBook(of: publication, in: collection, image: thumbnailImage, for: user)
            log.d("Book is added for id: \(id.value)")
            state = .succeeded
            // 強制的に更新 -> Viewの再構築が発生するため注意
            NotificationCenter.default.postRefreshBookShelfAllCollection()
            analyticsService.log(event: .addBookByManual)
        } catch {
            log.e(error.localizedDescription)
            state = .failed
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
