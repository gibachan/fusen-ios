//
//  BookShelfSectionModel.swift
//  BookShelfSectionModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Foundation

final class BookShelfSectionModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository
    
    @Published var state: State = .initial
    @Published var collection: Collection
    @Published var pager: Pager<Book> = .empty
    
    init(
        collection: Collection,
        accountService: AccountServiceProtocol = AccountService.shared,
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.collection = collection
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onAppear() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            let pager = try await bookRepository.getBooks(for: user)
            log.d("finished=\(pager.finished)")
            DispatchQueue.main.async { [weak self] in
                self?.state = .succeeded
                self?.pager = pager
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
