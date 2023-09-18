//
//  AddBookViewModel.swift
//  AddBookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import Domain
import Foundation

final class AddBookViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceProtocol
    private let addBookByManualUseCase: AddBookByManualUseCase

    @Published var isSaveEnabled = false
    @Published var state: State = .initial

    init(
        analyticsService: AnalyticsServiceProtocol = AnalyticsService.shared,
        addBookByManualUseCase: AddBookByManualUseCase = AddBookByManualUseCaseImpl(accountService: AccountService.shared, bookRepository: BookRepositoryImpl())
    ) {
        self.analyticsService = analyticsService
        self.addBookByManualUseCase = addBookByManualUseCase
    }
    
    @MainActor
    func onTextChange(title: String, author: String) {
        isSaveEnabled = title.isNotEmpty
    }
    
    @MainActor
    func onSave(title: String, author: String, thumbnailImage: ImageData?, collection: Collection?) async {
        guard !state.isInProgress else { return }

        state = .loading
        do {
            let id = try await addBookByManualUseCase.invoke(title: title, author: author, thumbnailImage: thumbnailImage, collection: collection)
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
