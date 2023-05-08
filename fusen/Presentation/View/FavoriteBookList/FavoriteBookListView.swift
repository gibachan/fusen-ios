//
//  FavoriteBookListView.swift
//  FavoriteBookListView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/27.
//

import SwiftUI

struct FavoriteBookListView: View {
    @StateObject private var viewModel = FavoriteBookListViewModel()
    @State private var isAddPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(viewModel.pager.data, id: \.id.value) { book in
                    NavigationLink(destination: LazyView(BookView(bookId: book.id))) {
                        BookListItem(book: book)
                            .task {
                                await viewModel.onItemApper(of: book)
                            }
                    }
                }
                if viewModel.pager.data.isEmpty {
                    BookShelfEmptyItem()
                        .listRowSeparator(.hidden)
                }
            }
            .refreshable {
                await viewModel.onRefresh()
            }
            
            TrailingControlToolbar(
                trailingView: {
                    AddBookIcon()
                        .onTapGesture {
                            isAddPresented = true
                        }
                }
            )
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("お気に入りの書籍", displayMode: .inline)
        .loading(viewModel.state == .loading)
        .sheet(isPresented: $isAddPresented) {
            Task {
                await viewModel.onRefresh()
            }
        } content: {
            AddBookMenuView()
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

struct FavoriteBookListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteBookListView()
    }
}
