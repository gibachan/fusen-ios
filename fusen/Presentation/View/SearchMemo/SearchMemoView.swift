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
                List {
                    ForEach(viewStore.searchedMemos, id: \.id) { memo in
                        NavigationLink(destination: LazyView(EditMemoView(memo: memo))) {
                            MemoListItem(memo: memo)
                        }
                    }

                    if viewStore.isEmptyResult {
                        NotFoundItem()
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
