//
//  SearchMemoTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import ComposableArchitecture
import Domain
@testable import fusen
import XCTest

class SearchMemoTests: XCTestCase {
    @MainActor
    func testSearchAndClearSearchText() async {
        let store = TestStore(
            initialState: SearchMemo.State()
        ) {
            SearchMemo()
        } withDependencies: {
            $0.searchMemoClient.invoke = { _, _ in [Memo.sample] }
        }

        await store.send(.typeSearchText("S")) {
            $0.searchText = "S"
        }
        await store.send(.executeSearching) {
            $0.isLoading = true
        }
        await store.receive(\.searched) {
            $0.isLoading = false
            $0.searchedMemos = [Memo.sample]
        }
        await store.send(.typeSearchText("")) {
            $0.searchText = ""
            $0.searchedMemos = []
        }
    }

    @MainActor
    func testSearchFailure() async {
        let store = TestStore(
            initialState: SearchMemo.State()
        ) {
            SearchMemo()
        } withDependencies: {
            $0.searchMemoClient.invoke = { _, _ in throw SearchMemosUseCaseError.badNetwork }
        }

        await store.send(.typeSearchText("S")) {
            $0.searchText = "S"
        }
        await store.send(.executeSearching) {
            $0.isLoading = true
        }
        await store.receive(\.searched) {
            $0.isLoading = false
            $0.destination = .alert(.networkError)
        }
    }
}
