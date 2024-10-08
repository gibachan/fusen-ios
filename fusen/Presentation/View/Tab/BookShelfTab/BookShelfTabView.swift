//
//  BookShelfTabView.swift
//  BookShelfTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

struct BookShelfTabView: View {
    @StateObject private var viewModel = BookShelfTabViewModel()
    @State private var isAddBookPresented = false
    @State private var isAddCollectionPresented = false
    @State private var isNavigated = false
    @State private var navigation: BookShelfNavigation = .none

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                if viewModel.isFavoriteVisible {
                    BookShelfFavoriteSection(isNavigated: $isNavigated, navigation: $navigation)
                }
                ForEach(viewModel.collections, id: \.id.value) { collection in
                    BookShelfCollectionSection(collection: collection, isNavigated: $isNavigated, navigation: $navigation)
                }
                if viewModel.state == .succeeded {
                    BookShelfAllSection(isNavigated: $isNavigated, navigation: $navigation)
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                await viewModel.onRefresh()
            }

            toolbarView
        }
        .listStyle(PlainListStyle())
        .loading(viewModel.state == .loading)
        .navigationBarTitle("本棚")
        .navigation(isActive: $isNavigated, destination: {
            switch navigation {
            case .none:
                EmptyView()
            case let .book(book: book):
                BookView(bookId: book.id)
            case .allBooks:
                BookListView()
            case .favoriteBookList:
                FavoriteBookListView()
            case .collection(collection: let collection):
                CollectionView(collection: collection)
            }
        })
        .sheet(isPresented: $isAddCollectionPresented) {
            Task {
                await viewModel.onRefresh()
            }
        } content: {
            NavigationView {
                AddCollectionView()
            }
        }
        .sheet(isPresented: $isAddBookPresented) {
            Task {
                await viewModel.onRefresh()
            }
        } content: {
            AddBookMenuView()
        }
        .task {
            await viewModel.onAppear()
        }
        .onReceive(NotificationCenter.default.bookShelfPopToRootPublisher()) { _ in
            isNavigated = false
        }
    }
}

private extension BookShelfTabView {
    var toolbarView: some View {
        HStack(alignment: .center) {
            Image.addCollection
                .resizable()
                .frame(width: 28, height: 22)
                .foregroundColor(.active)
                .onTapGesture {
                    isAddCollectionPresented = true
                }
            Spacer()
            Text(viewModel.booksCount)
                .font(.medium)
                .foregroundColor(.textSecondary)
            Spacer()
            AddBookIcon()
                .onTapGesture {
                    isAddBookPresented = true
                }
        }
        .padding(.horizontal, 24)
        .frame(height: 48)
        .border(Color.backgroundGray, width: 0.5)
    }
}

struct BookShelfTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfTabView()
    }
}
