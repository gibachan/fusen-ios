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
                },
                trailingAction: {
                    isAddPresented = true
                }
            )
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("お気に入りの書籍", displayMode: .inline)
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

struct FavoriteBookListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteBookListView()
    }
}
