//
//  BookViewModel.swift
//  BookViewModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import Data
import Domain
import Foundation

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

    var isLoading: Bool {
        switch state {
        case .loading:
            return true
        default:
            return false
        }
    }

    var isEmpty: Bool {
        switch state {
        case .failed:
            return true
        default:
            return false
        }
    }

    init(
        bookId: ID<Book>,
        getBookByIdUseCase: GetBookByIdUseCase = GetBookByIdUseCaseImpl(accountService: AccountService.shared, bookRepository: BookRepositoryImpl()),
        getReadingBookUseCase: GetReadingBookUseCase = GetReadingBookUseCaseImpl(accountService: AccountService.shared, userRepository: UserRepositoryImpl(), bookRepository: BookRepositoryImpl()),
        updateReadingBookUseCase: UpdateReadingBookUseCase = UpdateReadingBookUseCaseImpl(accountService: AccountService.shared, userRepository: UserRepositoryImpl()),
        updateFavoriteBookUseCase: UpdateFavoriteBookUseCase = UpdateFavoriteBookUseCaseImpl(accountService: AccountService.shared, bookRepository: BookRepositoryImpl()),
        deleteBookUseCase: DeleteBookUseCase = DeleteBookUseCaseImpl(accountService: AccountService.shared, bookRepository: BookRepositoryImpl()),
        getUserActionHistoryUseCase: GetUserActionHistoryUseCase = GetUserActionHistoryUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl()),
        confirmReadingBookDescriptionUseCase: ConfirmReadingBookDescriptionUseCase = ConfirmReadingBookDescriptionUseCaseImpl(userActionHistoryRepository: UserActionHistoryRepositoryImpl())
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

    @MainActor
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
            let userActionHistory = getUserActionHistoryUseCase.invoke()
            if !userActionHistory.didConfirmReadingBookDescription {
                NotificationCenter.default.postShowReadingBookDescription()
            }
            confirmReadingBookDescriptionUseCase.invoke()
        } catch {
            log.e(error.localizedDescription)
            readingBookState = .failed
            NotificationCenter.default.postError(message: .readingBookChange)
        }
    }

    @MainActor
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

    @MainActor
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

    @MainActor
    private func load() async {
        guard !state.isInProgress else { return }

        state = .loading
        do {
            let book = try await getBookByIdUseCase.invoke(id: bookId)
            let readingBook = try await getReadingBookUseCase.invoke()
            self.state = .loaded(book: book)
            self.isReadingBook = readingBook?.id == book.id
            self.isFavorite = book.isFavorite
        } catch {
            log.e(error.localizedDescription)
            self.state = .failed
            // すべての書籍画面から書籍を削除した場合、画面を閉じると同時に.taskが呼ばれ、
            // 削除済み書籍データを取得してエラーとなるので、一旦エラーを外しておく
            // NotificationCenter.default.postError(message: .network)
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
