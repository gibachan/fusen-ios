//
//  HomeTabViewModel.swift
//  HomeTabViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Foundation

final class HomeTabViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    @Published var state: State = .initial
    @Published var latestBooks: [Book] = []
    
    init(accountService: AccountServiceProtocol = AccountService.shared,
         bookRepository: BookRepository = BookRepositoryImpl()) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let books = try await bookRepository.getLatestBooks(for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.latestBooks = books
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
