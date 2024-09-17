//
//  MemoListView.swift
//  MemoListView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct MemoListView: View {
    @StateObject private var viewModel = MemoListViewModel()
    @State private var isAddPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(viewModel.pager.data, id: \.id.value) { memo in
                    NavigationLink(destination: LazyView(EditMemoView(memo: memo))) {
                        MemoListItem(memo: memo)
                            .task {
                                await viewModel.onItemApper(of: memo)
                            }
                    }
                }
                if viewModel.pager.data.isEmpty {
                    BookEmptyMemoItem()
                        .listRowSeparator(.hidden)
                }
            }
            .refreshable {
                await viewModel.onRefresh()
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("すべてのメモ", displayMode: .inline)
        .loading(viewModel.state == .loading)
        .sheet(isPresented: $isAddPresented) {
            print("dismissed")
        } content: {
            AddBookMenuView()
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

struct MemoListView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListView()
    }
}
