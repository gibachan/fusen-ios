//
//  SearchMemo.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import ComposableArchitecture
import Foundation

// MARK: - Search memo feature domain

struct SearchMemo: ReducerProtocol {
    struct State: Equatable {
        var searchText = ""
        var isLoading = false
        var searchedMemos: [Memo] = []
        var isEmptyResult = false
    }

    enum Action: Equatable {
        case typeSearchText(String)
        case executeSearching
        case searched(TaskResult<[Memo]>)
    }

    private enum SearchMemoID {}
    // TODO: DI
    private let searchMemosUseCase: SearchMemosUseCase = SearchMemosUseCaseImpl()

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
                await .searched(TaskResult { try await self.searchMemosUseCase.invoke(searchText: searchText) })
            }

        case .searched(.failure):
            state.isLoading = false
            state.searchedMemos = []
            state.isEmptyResult = false
            return .none

        case let .searched(.success(response)):
            state.isLoading = false
            state.searchedMemos = response
            state.isEmptyResult = response.isEmpty
            return .none
        }
    }
}
