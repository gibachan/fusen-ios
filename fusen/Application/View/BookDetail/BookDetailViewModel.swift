//
//  BookDetailViewModel.swift
//  BookDetailViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import Foundation

final class BookDetailViewModel: ObservableObject {
    private let accountService: AccountServiceProtocol
    private let bookRepository: BookRepository

    @Published var state: State = .initial
    
    init(accountService: AccountServiceProtocol = AccountService.shared,
         bookRepository: BookRepository = BookRepositoryImpl()) {
        self.accountService = accountService
        self.bookRepository = bookRepository
    }
    
    func onUpdate() async {
        
    }
    
    func onDelete() async {
        
    }
    
    enum State {
        case initial
        case loading
        case succeeded
        case failed
    }
}
