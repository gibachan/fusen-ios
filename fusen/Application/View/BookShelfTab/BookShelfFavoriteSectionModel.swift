//
//  BookShelfFavoriteSectionModel.swift
//  BookShelfFavoriteSectionModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/22.
//

import Foundation

final class BookShelfFavoriteSectionModel: ObservableObject {
    private static let maxDiplayBookCount = 6
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    @Published var state: State = .initial
    @Published var books: [Book] = []
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await bookRepository.getFavoriteBooks(for: user, forceRefresh: false)
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.books = Array(pager.data.prefix(Self.maxDiplayBookCount))
            }
        } catch {
            log.e(error.localizedDescription)
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