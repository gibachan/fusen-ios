//
//  BookShelfAllSectionModel.swift
//  BookShelfAllSectionModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/22.
//

import Foundation

@MainActor
final class BookShelfAllSectionModel: ObservableObject {
    private static let maxDiplayBookCount = 6
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    @Published var state: State = .initial
    @Published var books: [[Book]] = []
    
    init(
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onAppear() async {
        await getBooks()
    }
    
    func onRefresh() async {
        await getBooks()
    }
    
    private func getBooks() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await bookRepository.getAllBooks(sortedBy: .default, for: user, forceRefresh: false)
            state = .succeeded
            
            var displayBooks = Array(pager.data.prefix(Self.maxDiplayBookCount))
            var resultBooks: [[Book]] = []
            while !displayBooks.isEmpty {
                let books = Array(displayBooks.prefix(2))
                displayBooks = Array(displayBooks.dropFirst(2))
                resultBooks.append(books)
            }
            books = resultBooks
        } catch {
            log.e(error.localizedDescription)
            state = .failed
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
