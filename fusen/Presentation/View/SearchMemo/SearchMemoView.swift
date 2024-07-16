//
//  SearchMemoView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import ComposableArchitecture
import Domain
import SwiftUI

struct SearchMemoView: View {
    @Bindable var store: StoreOf<SearchMemo>

    @State private var searchText = ""
    @State private var searchType: SearchMemoType = .text

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                Picker("", selection: $searchType) {
                    ForEach(SearchMemoType.allCases, id: \.self) { type in
                        Text(type.description)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 32, trailing: 16))
                .pickerStyle(.segmented)
                .onChange(of: searchType) { type in
                    viewStore.send(.selectType(type))
                }

                if viewStore.isEmptyResult {
                    notFoundView()
                } else if viewStore.searchedMemos.isEmpty {
                    Text("\(viewStore.searchType == .text ? "メモ" : "書籍の引用")の内容から最大20件を検索できます。\n\n※大きすぎるメモは検索できないことがあります。")
                        .font(.small)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(16)
                } else {
                    List {
                        ForEach(viewStore.searchedMemos, id: \.id) { memo in
                            NavigationLink(destination: LazyView(EditMemoView(memo: memo))) {
                                MemoListItem(memo: memo)
                            }
                        }
                    }
                }
                Spacer()
            }
            .loading(viewStore.isLoading)
            .alert(
                $store.scope(
                    state: \.destination?.alert,
                    action: \.destination.alert
                )
            )
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { newValue in
                viewStore.send(.typeSearchText(newValue))
            })
            .onSubmit(of: .search) {
                viewStore.send(.executeSearching)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("メモを検索")
        }
    }
}

private extension SearchMemoView {
    func notFoundView() -> some View {
        Text("メモは見つかりませんでした")
            .font(.medium)
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(16)
    }
}

struct SearchMemoView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMemoView(store: Store(initialState: SearchMemo.State()) {
            SearchMemo()
        })
    }
}
