//
//  BookViewModel.swift
//  BookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import Foundation

@MainActor
final class BookViewModel: ObservableObject {
    private let bookId: ID<Book>
    private let getBookByIdUseCase: GetBookByIdUseCase
    private let getReadingBookUseCase: GetReadingBookUseCase
    private let updateReadingBookUseCase: UpdateReadingBookUseCase
    private let updateFavoriteBookUseCase: UpdateFavoriteBookUseCase
    private let deleteBookUseCase: DeleteBookUseCase
    private let getUserActionHistoryUseCase: GetUserActionHistoryUseCase
    private let confirmReadingBookDescriptionUseCase: ConfirmReadingBookDescriptionUseCase
    
    private var favoriteState: FavoriteState = .initial
    private var readingBookState: ReadingBookState = .initial
    
    @Published var isFavorite = false
    @Published var isReadingBook = false
    @Published var state: State = .initial
    
    init(
        bookId: ID<Book>,
        getBookByIdUseCase: GetBookByIdUseCase = GetBookByIdUseCaseImpl(),
        getReadingBookUseCase: GetReadingBookUseCase = GetReadingBookUseCaseImpl(),
        updateReadingBookUseCase: UpdateReadingBookUseCase = UpdateReadingBookUseCaseImpl(),
        updateFavoriteBookUseCase: UpdateFavoriteBookUseCase = UpdateFavoriteBookUseCaseImpl(),
        deleteBookUseCase: DeleteBookUseCase = DeleteBookUseCaseImpl(),
        getUserActionHistoryUseCase: GetUserActionHistoryUseCase = GetUserActionHistoryUseCaseImpl(),
        confirmReadingBookDescriptionUseCase: ConfirmReadingBookDescriptionUseCase = ConfirmReadingBookDescriptionUseCaseImpl()
    ) {
        self.bookId = bookId
        self.getBookByIdUseCase = getBookByIdUseCase
        self.getReadingBookUseCase = getReadingBookUseCase
        self.updateReadingBookUseCase = updateReadingBookUseCase
        self.updateFavoriteBookUseCase = updateFavoriteBookUseCase
        self.deleteBookUseCase = deleteBookUseCase
        self.getUserActionHistoryUseCase = getUserActionHistoryUseCase
        self.confirmReadingBookDescriptionUseCase = confirmReadingBookDescriptionUseCase
    }
    
    func onAppear() async {
        await load()
    }
    
    func onRefresh() async {
        await load()
    }
    
    func onReadingToggle() async {
        guard case let .loaded(book) = state else { return }
        guard !readingBookState.isInProgress else { return }
        
        readingBookState = .loading
        do {
            let readingBook: Book? = isReadingBook ? nil : book
            try await updateReadingBookUseCase.invoke(readingBook: readingBook)
            readingBookState = .loaded
            isReadingBook = readingBook != nil
            
            // Confirt reading book description
            let userActionHistory = await getUserActionHistoryUseCase.invoke()
            if !userActionHistory.didConfirmReadingBookDescription {
                NotificationCenter.default.postShowReadingBookDescription()
            }
            await confirmReadingBookDescriptionUseCase.invoke()
        } catch {
            log.e(error.localizedDescription)
            readingBookState = .failed
            NotificationCenter.default.postError(message: .readingBookChange)
        }
    }
    
    func onFavoriteChange(isFavorite: Bool) async {
        guard case let .loaded(book) = state else { return }
        guard !favoriteState.isInProgress else { return }

        favoriteState = .loading
        do {
            try await updateFavoriteBookUseCase.invoke(book: book, isFavorite: isFavorite)
            self.favoriteState = .loaded
            self.isFavorite = isFavorite
        } catch {
            log.e(error.localizedDescription)
            self.favoriteState = .failed
            NotificationCenter.default.postError(message: .favoriteBookChange)
        }
    }
    
    func onDelete() async {
        guard case let .loaded(book) = state else { return }
        
        state = .loading
        do {
            try await deleteBookUseCase.invoke(book: book)
            state = .deleted
        } catch {
            log.e(error.localizedDescription)
            state = .failed
            NotificationCenter.default.postError(message: .deleteBook)
        }
    }
    
    private func load() async {
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

            let book = try await getBookByIdUseCase.invoke(id: bookId)
            let readingBook = try await getReadingBookUseCase.invoke()
            self.state = .loaded(book: book)
            self.isReadingBook = readingBook?.id == book.id
            self.isFavorite = book.isFavorite
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
            NotificationCenter.default.postError(message: .network)
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