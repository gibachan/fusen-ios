//
//  SearchMemoView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import ComposableArchitecture
import SwiftUI

struct SearchMemoView: View {
    let store: StoreOf<SearchMemo>

    @State private var searchText = ""

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                if viewStore.isEmptyResult {
                    notFoundView()
                } else if viewStore.searchedMemos.isEmpty {
                    descriptionView()
                } else {
                    List {
                        ForEach(viewStore.searchedMemos, id: \.id) { memo in
                            NavigationLink(destination: LazyView(EditMemoView(memo: memo))) {
                                MemoListItem(memo: memo)
                            }
                        }
                    }
                }
            }
            .loading(viewStore.isLoading)
            .alert(
                store.scope(state: \.alert),
                dismiss: .alertDismissed
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
    func descriptionView() -> some View {
        Text("メモの内容から最大20件を検索できます。")
            .font(.medium)
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(16)
    }

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
        SearchMemoView(
            store: Store(
                initialState: SearchMemo.State(),
                reducer: SearchMemo()
            )
        )
    }
}
