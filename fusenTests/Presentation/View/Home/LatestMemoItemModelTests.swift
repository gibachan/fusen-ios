//
//  LatestMemoItemModelTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/24.
//

import Combine
import Domain
import XCTest

@testable import fusen

class LatestMemoItemModelTests: XCTestCase {
    func testOnAppear() async {
        let getBookByIdUseCase = MockGetBookByIdUseCase(withResult: Book.sample)
        let viewModel = LatestMemoItemModel(memo: Memo.sample, getBookByIdUseCase: getBookByIdUseCase)

        var states: [LatestMemoItemModel.State] = []
        var memos: [Memo] = []
        var books: [Book?] = []
        var cancellables = Set<AnyCancellable>()
        viewModel.$state
            .sink(receiveValue: { state in
                states.append(state)
            })
            .store(in: &cancellables)
        viewModel.$memo
            .sink(receiveValue: { memo in
                memos.append(memo)
            })
            .store(in: &cancellables)
        viewModel.$book
            .sink(receiveValue: { book in
                books.append(book)
            })
            .store(in: &cancellables)

        await viewModel.onAppear()
        cancellables.removeAll()

        XCTAssertEqual(states.count, 3)
        XCTAssertEqual(states[0], .initial)
        XCTAssertEqual(states[1], .loading)
        XCTAssertEqual(states[2], .succeeded)

        XCTAssertEqual(memos.count, 1)
        XCTAssertEqual(memos[0], Memo.sample)

        XCTAssertEqual(books.count, 2)
        XCTAssertNil(books[0])
        XCTAssertEqual(books[1], Book.sample)
    }

    func testOnAppearWhenCorrespondingBookIsNotFound() async {
        let getBookByIdUseCase = MockGetBookByIdUseCase(withError: .notFound)
        let viewModel = LatestMemoItemModel(memo: Memo.sample, getBookByIdUseCase: getBookByIdUseCase)

        var states: [LatestMemoItemModel.State] = []
        var memos: [Memo] = []
        var books: [Book?] = []
        var cancellables = Set<AnyCancellable>()
        viewModel.$state
            .sink(receiveValue: { state in
                states.append(state)
            })
            .store(in: &cancellables)
        viewModel.$memo
            .sink(receiveValue: { memo in
                memos.append(memo)
            })
            .store(in: &cancellables)
        viewModel.$book
            .sink(receiveValue: { book in
                books.append(book)
            })
            .store(in: &cancellables)

        await viewModel.onAppear()
        cancellables.removeAll()

        XCTAssertEqual(states.count, 3)
        XCTAssertEqual(states[0], .initial)
        XCTAssertEqual(states[1], .loading)
        XCTAssertEqual(states[2], .failed)

        XCTAssertEqual(memos.count, 1)
        XCTAssertEqual(memos[0], Memo.sample)

        XCTAssertEqual(books.count, 1)
        XCTAssertNil(books[0])
    }
}

private final class MockGetBookByIdUseCase: GetBookByIdUseCase {
    private let result: Book?
    private let error: GetBookByIdUseCaseError?

    init(withResult result: Book) {
        self.result = result
        self.error = nil
    }

    init(withError error: GetBookByIdUseCaseError) {
        self.result = nil
        self.error = error
    }

    func invoke(id: ID<Book>) async throws -> Book {
        if let result = result {
            return result
        } else {
            throw error!
        }
    }
}
