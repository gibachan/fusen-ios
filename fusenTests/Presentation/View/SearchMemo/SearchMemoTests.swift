//
//  SearchMemoTests.swift
//  fusenTests
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import ComposableArchitecture
@testable import fusen
import XCTest

@MainActor
class SearchMemoTests: XCTestCase {
    func testSearchAndClearSearchText() async {
        let store = TestStore(
            initialState: SearchMemo.State(),
            reducer: SearchMemo()
        ) {
            $0.searchMemoClient.invoke = { _ in [Memo.sample] }
        }

        await store.send(.typeSearchText("S")) {
            $0.searchText = "S"
        }
        await store.send(.executeSearching) {
            $0.isLoading = true
        }
        await store.receive(.searched(.success([Memo.sample]))) {
            $0.isLoading = false
            $0.searchedMemos = [Memo.sample]
        }
        await store.send(.typeSearchText("")) {
            $0.searchText = ""
            $0.searchedMemos = []
        }
    }

    func testSearchFailure() async {
        let store = TestStore(
            initialState: SearchMemo.State(),
            reducer: SearchMemo()
        ) {
            $0.searchMemoClient.invoke = { _ in throw SearchMemosUseCaseError.badNetwork }
        }

        await store.send(.typeSearchText("S")) {
            $0.searchText = "S"
        }
        await store.send(.executeSearching) {
            $0.isLoading = true
        }
        await store.receive(.searched(.failure(SearchMemosUseCaseError.badNetwork))) {
            $0.isLoading = false
            $0.alert = AlertState {
              TextState("通信エラー")
            } actions: {
              ButtonState(role: .cancel) {
                TextState("閉じる")
              }
            } message: {
              TextState("エラーが発生しました。ネットワーク環境を確認してみてください。")
            }
        }
    }
}
