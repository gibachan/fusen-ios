//
//  SearchTabView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/22.
//

import SwiftUI

private enum SearchTabViewState {
    case initial
    case loading
    case refreshing
    case succeeded
    case failed

    var isInProgress: Bool {
        switch self {
        case .initial, .succeeded, .failed:
            return false
        case .loading, .refreshing:
            return true
        }
    }
}

struct SearchTabView: View {
    @State private var searchText = ""
    @State private var state: SearchTabViewState = .initial
    @State private var foundMemos: [Memo] = []

    private let searchMemosUseCase: SearchMemosUseCase = SearchMemosUseCaseImpl()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(foundMemos, id: \.id) { memo in
                    MemoListItem(memo: memo)
                }
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            Task {
                do {
                    state = .loading
                    foundMemos = try await searchMemosUseCase.invoke(searchText: searchText)
                    state = .succeeded
                } catch {
                    state = .failed
                    print(error)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("検索")
    }
}

private struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchTabView()
        }
    }
}
