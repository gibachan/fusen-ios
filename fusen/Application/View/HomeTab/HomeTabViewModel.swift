//
//  HomeTabViewModel.swift
//  HomeTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Foundation

@MainActor
final class HomeTabViewModel: ObservableObject {
    private let latestBooksCount = 4
    private let latestMemosCount = 4
    
    private let getReadingBookUseCase: GetReadingBookUseCase
    private let getLatestDataUseCase: GetLatestDataUseCase
    
    @Published var state: State = .initial
    @Published var readingBook: Book?
    
    init(
        getReadingBookUseCase: GetReadingBookUseCase = GetReadingBookUseCaseImpl(),
        getLatestDataUseCase: GetLatestDataUseCase = GetLatestDataUseCaseImpl()
    ) {
        self.getReadingBookUseCase = getReadingBookUseCase
        self.getLatestDataUseCase = getLatestDataUseCase
    }
    
    func onAppear() async {
        await loadAll()
    }
    
    func onRefresh() async {
        await loadAll()
    }
    
    private func loadAll() async {
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            self.readingBook = try? await getReadingBookUseCase.invoke()
            
            let latestData = try await getLatestDataUseCase.invoke(booksCount: latestBooksCount, memosCount: latestMemosCount)
            if latestData.books.isEmpty && latestData.memos.isEmpty {
                state = .empty
            } else {
                state = .loaded(latestBooks: latestData.books, latestMemos: latestData.memos)
            }
        } catch {
            log.e(error.localizedDescription)
            state = .failed
            NotificationCenter.default.postError(message: .network)
        }
    }
    
    enum State {
        case initial
        case loading
        case loaded(latestBooks: [Book], latestMemos: [Memo])
        case empty
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .empty, .failed:
                return false
            case .loading:
                return true
            }
        }
    }
}
