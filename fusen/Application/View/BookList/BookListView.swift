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
                    Image.add
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.active)
                },
                trailingAction: {
                    isAddPresented = true
                }
            )
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("すべての書籍", displayMode: .inline)
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

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
    }
}
