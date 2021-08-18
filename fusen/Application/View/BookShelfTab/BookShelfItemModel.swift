//
//  BookShelfItemModel.swift
//  BookShelfItemModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import Foundation

final class BookShelfItemModel: ObservableObject {
    private let bookId: ID<Book>
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    @Published var state: State = .initial
    @Published var book: Book?
    
    init(
        bookId: ID<Book>,
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.bookId = bookId
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let book = try await bookRepository.getBook(by: bookId, for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.book = book
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    // associated valueに変更があってもSwiftUIは検知してくれない
    // (state自体が変更されない限りViewが更新されない）
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
