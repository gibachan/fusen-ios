//
//  BookViewModel.swift
//  BookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import Foundation

final class BookViewModel: ObservableObject {
    private let bookId: ID<Book>
    private let accountService: AccountServiceProtocol
    private let userRepository: UserRepository
    private let bookRepository: BookRepository
    
    private var favoriteState: FavoriteState = .initial
    private var readingBookState: ReadingBookState = .initial
    
    @Published var isFavorite = false
    @Published var isReadingBook = false
    @Published var state: State = .initial
    
    init(
        bookId: ID<Book>,
        accountService: AccountServiceProtocol = AccountService.shared,
        userRepository: UserRepository = UserRepositoryImpl(),
        bookRepository: BookRepository = BookRepositoryImpl()
    ) {
        self.bookId = bookId
        self.accountService = accountService
        self.userRepository = userRepository
        self.bookRepository = bookRepository
    }
    
    func onAppear() async {
        await load()
    }
    
    func onRefresh() async {
        await load()
    }
    
    func onReadingToggle() async {
        guard let user = accountService.currentUser else { return }
        guard case let .loaded(book) = state else { return }
        guard !readingBookState.isInProgress else { return }
        
        readingBookState = .loading
        do {
            let readingBook: Book? = isReadingBook ? nil : book
            try await userRepository.update(readingBook: readingBook, for: user)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.readingBookState = .loaded
                self.isReadingBook = readingBook != nil
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                // FIXME: error handling
                guard let self = self else { return }
                self.readingBookState = .failed
            }
        }
    }
    
    func onFavoriteChange(isFavorite: Bool) async {
        guard let user = accountService.currentUser else { return }
        guard case let .loaded(book) = state else { return }
        guard !favoriteState.isInProgress else { return }

        favoriteState = .loading
        do {
            try await bookRepository.update(book: book, isFavorite: isFavorite, for: user)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.favoriteState = .loaded
                self.isFavorite = isFavorite
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                // FIXME: error handling
                guard let self = self else { return }
                self.favoriteState = .failed
            }
        }
    }
    
    func onDelete() async {
        guard let user = accountService.currentUser else { return }
        guard case let .loaded(book) = state else { return }
        
        state = .loading
        do {
            try await bookRepository.delete(book: book, for: user)
            DispatchQueue.main.async { [weak self] in
                self?.state = .deleted
            }
        } catch {
            // FIXME: error handling
            print(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.state = .failed
            }
        }
    }
    
    private func load() async {
        guard let user = accountService.currentUser else { return }
        guard !state.isInProgress else { return }
        
        state = .loading
        do {
            // async letで例外が発生したときに何故かキャッチできずにクラッシュする
//            async let userInfo = userRepository.getInfo(for: user)
//            async let newBook = bookRepository.getBook(by: book.id, for: user)
//            async let memoPager = memoRepository.getMemos(of: book, for: user, forceRefresh: false)
//            let result = try await (userInfo: userInfo, book: newBook, memoPager: memoPager)
//            DispatchQueue.main.async { [weak self] in
//                self?.state = .succeeded
//                self?.isReadingBook = result.userInfo.readingBookId == result.book.id
//                self?.book = result.book
//                self?.memoPager = result.memoPager
//            }

            let userInfo = try await userRepository.getInfo(for: user)
            let book = try await bookRepository.getBook(by: bookId, for: user)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .loaded(book: book)
                self.isReadingBook = userInfo.readingBookId == book.id
                self.isFavorite = book.isFavorite
            }
        } catch {
            // FIXME: error handling
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
            }
        }
    }
    
    enum State {
        case initial
        case loading
        case loaded(book: Book)
        case deleted
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .failed, .deleted:
                return false
            case .loading:
                return true
            }
        }
    }
    
    enum FavoriteState {
        case initial
        case loading
        case loaded
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .failed:
                return false
            case .loading:
                return true
            }
        }
    }
    
    enum ReadingBookState {
        case initial
        case loading
        case loaded
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .failed:
                return false
            case .loading:
                return true
            }
        }
    }
}
