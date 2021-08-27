//
//  BookMemoSectionModel.swift
//  BookMemoSectionModel
//
//  Created by Tatsuyuki Kobayashi on 2021/08/26.
//

import Foundation

final class BookMemoSectionModel: ObservableObject {
    private let bookId: ID<Book>
    private let accountService: AccountServiceProtocol
    private let memoRepository: MemoRepository
    
    @Published var state: State = .initial
    @Published var memoPager: Pager<Memo> = .empty
    
    init(
        bookId: ID<Book>,
        accountService: AccountServiceProtocol = AccountService.shared,
        memoRepository: MemoRepository = MemoRepositoryImpl()
    ) {
        self.bookId = bookId
        self.accountService = accountService
        self.memoRepository = memoRepository
    }
    
    func onAppear() async {
        await load()
    }
    
    func onRefresh() async {
        await load()
    }
    
    func onItemApper(of memo: Memo) async {
        guard case .loaded = state, !memoPager.finished else { return }
        guard let user = accountService.currentUser else { return }
        guard let lastMemo = memoPager.data.last else { return }
        
        if memo.id == lastMemo.id {
            //            state = .loadingNext
            do {
                let pager = try await memoRepository.getNextMemos(of: bookId, for: user)
                log.d("finished=\(pager.finished)")
                DispatchQueue.main.async { [weak self] in
                    self?.memoPager = pager
                }
            } catch {
                log.e(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.state = .failed
                }
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
            
            let memoPager = try await memoRepository.getMemos(of: bookId, for: user, forceRefresh: false)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.memoPager = memoPager
                self.state = .loaded(memos: memoPager.data)
            }
        } catch {
            log.e(error.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.state = .failed
                NotificationCenter.default.postError(message: .getMemo)
            }
        }
    }
    
    enum State {
        case initial
        case loaded(memos: [Memo])
        case loading
        case loadingNext
        case failed
        
        var isInProgress: Bool {
            switch self {
            case .initial, .loaded, .failed:
                return false
            case .loading, .loadingNext:
                return true
            }
        }
    }
}
