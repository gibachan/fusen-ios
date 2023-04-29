//
//  SearchMemo.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import ComposableArchitecture
import Foundation

// MARK: - Search memo feature domain

struct SearchMemoClient {
  var invoke: (String) async throws -> [Memo]
}

extension SearchMemoClient: DependencyKey {
  static let liveValue = Self(
    invoke: { searchText in
        let useCase = SearchMemosUseCaseImpl()
        return try await useCase.invoke(searchText: searchText)
    }
  )
}

extension DependencyValues {
  var searchMemoClient: SearchMemoClient {
    get { self[SearchMemoClient.self] }
    set { self[SearchMemoClient.self] = newValue }
  }
}

struct SearchMemo: ReducerProtocol {
    struct State: Equatable {
        var searchText = ""
        var isLoading = false
        var searchedMemos: [Memo] = []
        var isEmptyResult = false
        var alert: AlertState<Action>?
    }

    enum Action: Equatable {
        case typeSearchText(String)
        case executeSearching
        case searched(TaskResult<[Memo]>)
        case alertDismissed
    }

    private enum SearchMemoID {}

    @Dependency(\.searchMemoClient) var searchMemoClient: SearchMemoClient

    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case let .typeSearchText(searchText):
            state.searchText = searchText
            if searchText.isEmpty {
                state.searchedMemos = []
                state.isEmptyResult = false
                return .cancel(id: SearchMemoID.self)
            } else {
                return .none
            }
        case .executeSearching:
            state.isLoading = true
            return .task { [searchText = state.searchText] in
                await .searched(TaskResult { try await self.searchMemoClient.invoke(searchText) })
            }

        case .searched(.failure):
            state.isLoading = false
            state.searchedMemos = []
            state.isEmptyResult = false
            state.alert = AlertState {
              TextState("通信エラー")
            } actions: {
              ButtonState(role: .cancel) {
                TextState("閉じる")
              }
            } message: {
              TextState("エラーが発生しました。ネットワーク環境を確認してみてください。")
            }
            return .none

        case let .searched(.success(response)):
            state.isLoading = false
            state.searchedMemos = response
            state.isEmptyResult = response.isEmpty
            return .none

        case .alertDismissed:
          state.alert = nil
          return .none
        }
    }
}
