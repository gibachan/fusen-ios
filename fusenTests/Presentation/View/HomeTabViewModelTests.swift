//
//  HomeTabViewModelTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2021/09/23.
//

import Combine
import XCTest

@testable import fusen

class HomeTabViewModelTests: XCTestCase {
    func testOnAppear() async {
        let getReadingBookUseCase = MockGetReadingBookUseCase(withResult: Book.sample)
        let getLatestDataUseCase = MockGetLatestDataUseCase(withResult: LatestData(books: [Book.sample], memos: [Memo.sample]))
        let viewModel = HomeTabViewModel(getReadingBookUseCase: getReadingBookUseCase, getLatestDataUseCase: getLatestDataUseCase)
        
        var states: [HomeTabViewModel.State] = []
        var readingBooks: [Book?] = []
        var cancellables = Set<AnyCancellable>()
        viewModel.$state
            .sink(receiveValue: { state in
                states.append(state)
            })
            .store(in: &cancellables)
        viewModel.$readingBook
            .sink(receiveValue: { readingBook in
                readingBooks.append(readingBook)
            })
            .store(in: &cancellables)
        
        await viewModel.onAppear()
        cancellables.removeAll()
        
        XCTAssertEqual(states.count, 3)
        XCTAssertEqual(states[0], .initial)
        XCTAssertEqual(states[1], .loading)
        XCTAssertEqual(states[2], .loaded(latestBooks: [Book.sample], latestMemos: [Memo.sample]))
        XCTAssertEqual(readingBooks.count, 2)
        XCTAssertNil(readingBooks[0])
        XCTAssertEqual(readingBooks[1], Book.sample)
    }
    
    func testOnRefresh() async {
        let getReadingBookUseCase = MockGetReadingBookUseCase(withResult: Book.sample)
        let getLatestDataUseCase = MockGetLatestDataUseCase(withResult: LatestData(books: [Book.sample], memos: [Memo.sample]))
        let viewModel = HomeTabViewModel(getReadingBookUseCase: getReadingBookUseCase, getLatestDataUseCase: getLatestDataUseCase)
        
        var states: [HomeTabViewModel.State] = []
        var readingBooks: [Book?] = []
        var cancellables = Set<AnyCancellable>()
        viewModel.$state
            .sink(receiveValue: { state in
                states.append(state)
            })
            .store(in: &cancellables)
        viewModel.$readingBook
            .sink(receiveValue: { readingBook in
                readingBooks.append(readingBook)
            })
            .store(in: &cancellables)
        
        await viewModel.onRefresh()
        cancellables.removeAll()
        
        XCTAssertEqual(states.count, 3)
        XCTAssertEqual(states[0], .initial)
        XCTAssertEqual(states[1], .loading)
        XCTAssertEqual(states[2], .loaded(latestBooks: [Book.sample], latestMemos: [Memo.sample]))
        XCTAssertEqual(readingBooks.count, 2)
        XCTAssertNil(readingBooks[0])
        XCTAssertEqual(readingBooks[1], Book.sample)
    }
}

private final class MockGetReadingBookUseCase: GetReadingBookUseCase {
    private let result: Book?
    private let error: GetReadingBookUseCaseError?
    
    init(withResult result: Book?) {
        self.result = result
        self.error = nil
    }
    
    init(withError error: GetReadingBookUseCaseError) {
        self.result = nil
        self.error = error
    }
    
    func invoke() async throws -> Book? {
        if let result = result {
            return result
        } else {
            throw error!
        }
    }
}

private final class MockGetLatestDataUseCase: GetLatestDataUseCase {
    private let result: LatestData?
    private let error: GetLatestDataUseCaseError?
    
    init(withResult result: LatestData?) {
        self.result = result
        self.error = nil
    }
    
    init(withError error: GetLatestDataUseCaseError) {
        self.result = nil
        self.error = error
    }
    
    func invoke(booksCount: Int, memosCount: Int) async throws -> LatestData {
        if let result = result {
            return result
        } else {
            throw error!
        }
    }
}
