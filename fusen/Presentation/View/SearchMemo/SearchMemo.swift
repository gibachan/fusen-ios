//
//  SearchMemo.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import ComposableArchitecture
import Data
import Domain
import Foundation

// MARK: - Search memo feature domain

struct SearchMemoClient {
    var invoke: (String, SearchMemoType) async throws -> [Memo]
}

extension SearchMemoClient: DependencyKey {
  static let liveValue = Self(
    invoke: { searchText, searchType in
        let useCase = SearchMemosUseCaseImpl(accountService: AccountService.shared, searchAPIKeyRepository: SearchAPIKeyRepositoryImpl(), searchRepository: SearchRepositoryImpl(), memoRepository: MemoRepositoryImpl())
        return try await useCase.invoke(
            searchText: searchText,
            searchType: searchType
        )
    }
  )
}

extension DependencyValues {
  var searchMemoClient: SearchMemoClient {
    get { self[SearchMemoClient.self] }
    set { self[SearchMemoClient.self] = newValue }
  }
}

extension SearchMemoType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .text:
            return "メモで検索"
        case .quote:
            return "書籍からの引用で検索"
        }
    }
}

@Reducer
struct SearchMemo {
    @ObservableState
    struct State: Equatable {
        var searchText = ""
        var searchType = SearchMemoType.text
        var isLoading = false
        var searchedMemos: [Memo] = []
        var isEmptyResult = false

        @Presents var destination: Destination.State?
    }

    enum Action: BindableAction {
        case typeSearchText(String)
        case selectType(SearchMemoType)
        case executeSearching
        case searched(TaskResult<[Memo]>)

        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
    }

    @Dependency(\.searchMemoClient) var searchMemoClient: SearchMemoClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .typeSearchText(searchText):
                state.searchText = searchText
                if searchText.isEmpty {
                    state.searchedMemos = []
                    state.isEmptyResult = false
                    return .none
                } else {
                    return .none
                }

            case let .selectType(searchMemoType):
                state.searchType = searchMemoType
                state.searchedMemos = []
                state.isEmptyResult = false
                return .none

            case .executeSearching:
                state.isLoading = true
                return .run { [searchText = state.searchText, searchType = state.searchType] send in
                    await send(.searched(TaskResult { try await self.searchMemoClient.invoke(searchText, searchType) }))
                }

            case .searched(.failure):
                state.isLoading = false
                state.searchedMemos = []
                state.isEmptyResult = false
                state.destination = .alert(.networkError)
                return .none

            case let .searched(.success(response)):
                state.isLoading = false
                state.searchedMemos = response
                state.isEmptyResult = response.isEmpty
                return .none

            case .binding:
                return .none

            case .destination(.presented(.alert(.networkError))):
                return .none
            case .destination:
                return .none
            }
        }
    }
}

extension SearchMemo {
    @Reducer(state: .equatable)
    enum Destination {
        case alert(AlertState<Alert>)

        enum Alert: Equatable {
            case networkError
        }
    }
}

extension AlertState where Action == SearchMemo.Destination.Alert {
    static let networkError = Self {
        TextState("通信エラー")
    } actions: {
        ButtonState(role: .cancel, action: .networkError) {
            TextState("閉じる")
        }
    } message: {
        TextState("エラーが発生しました。ネットワーク環境を確認してみてください。")
    }
}
