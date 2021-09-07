//
//  BookListView.swift
//  BookListView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()
    @State private var isAddPresented = false
    @State private var isSortPresented = false
    
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
                },
                trailingAction: {
                    isAddPresented = true
                }
            )
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("すべての書籍", displayMode: .inline)
        .navigationBarItems(trailing: SortButton {
            isSortPresented = true
        })
        .sheet(isPresented: $isAddPresented) {
            Task {
                await viewModel.onRefresh()
            }
        } content: {
            AddBookMenuView()
        }
        .actionSheet(isPresented: $isSortPresented) {
            ActionSheet(
                title: Text("書籍をソート"),
                buttons: [
                    .default(Text("作成日時でソート")) {
                        Task {
                            await viewModel.onSort(.createdAt)
                        }
                    },
                    .default(Text("タイトルでソート")) {
                        Task {
                            await viewModel.onSort(.title)
                        }
                    },
                    .default(Text("著者でソート")) {
                        Task {
                            await viewModel.onSort(.author)
                        }
                    },
                    .cancel()
                ]
            )
        }
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loadingNext, .refreshing:
                break
            case .loading:
                LoadingHUD.show()
            case .succeeded:
                LoadingHUD.dismiss()
            case .failed:
                LoadingHUD.dismiss()
            }
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
    }
}
