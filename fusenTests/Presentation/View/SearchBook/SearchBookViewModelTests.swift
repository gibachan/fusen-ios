//
//  SearchBookViewModelTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import Combine
import XCTest

@testable import fusen

class SearchBookViewModelTests: XCTestCase {
    func testAddBookFromPublicationWhichSearchedByTitle() async {
        let searchPublicationsByTitleUseCase = MockSearchPublicationsByTitleUseCase(success: [Publication.sample])
        let addBookByPublicationUseCase = MockAddBookByPublicationUseCase(success: .init(value: "hoge"))
        let viewModel = SearchBookViewModel(collection: nil,
                                            searchPublicationsByTitleUseCase: searchPublicationsByTitleUseCase,
                                            addBookByPublicationUseCase: addBookByPublicationUseCase)
        var states: [SearchBookViewModel.State] = []
        var cancellables = Set<AnyCancellable>()
        await viewModel.$state
            .sink(receiveValue: { state in
                states.append(state)
            })
            .store(in: &cancellables)
        
        await viewModel.onSearch(title: Publication.sample.title)
        await viewModel.onSelect(publication: Publication.sample)
        await viewModel.onAdd()
        
        cancellables.removeAll()

        XCTAssertEqual(states, [
            .initial,
            .loading,
            .loaded(publications: [Publication.sample]),
            .loading,
            .added
        ])
    }
    
    func testSearchErrorWhenItSearchesPublicationsByTitle() async {
        let searchPublicationsByTitleUseCase = MockSearchPublicationsByTitleUseCase(failure: .notFound)
        let addBookByPublicationUseCase = MockAddBookByPublicationUseCase(success: .init(value: "hoge"))
        let viewModel = SearchBookViewModel(collection: nil,
                                            searchPublicationsByTitleUseCase: searchPublicationsByTitleUseCase,
                                            addBookByPublicationUseCase: addBookByPublicationUseCase)
        var states: [SearchBookViewModel.State] = []
        var cancellables = Set<AnyCancellable>()
        await viewModel.$state
            .sink(receiveValue: { state in
                states.append(state)
            })
            .store(in: &cancellables)
        
        await viewModel.onSearch(title: Publication.sample.title)
        
        cancellables.removeAll()

        XCTAssertEqual(states, [
            .initial,
            .loading,
            .loadFailed
        ])
    }
}
