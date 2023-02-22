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
                BookShelfAllSection(isNavigated: $isNavigated, navigation: $navigation)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                await viewModel.onRefresh()
            }
            
            ControlToolbar(
                leadingView: {
                    Image.addCollection
                        .resizable()
                        .frame(width: 28, height: 22)
                        .foregroundColor(.active)
                        .onTapGesture {
                            isAddCollectionPresented = true
                        }
                },
                trailingView: {
                    AddBookIcon()
                        .onTapGesture {
                            isAddBookPresented = true
                        }
                }
            )
        }
        .listStyle(PlainListStyle())
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
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial:
                break
            case .loading:
                LoadingHUD.show()
            case .succeeded:
                LoadingHUD.dismiss()
            case .failed:
                LoadingHUD.dismiss()
            }
        }
        .onReceive(NotificationCenter.default.bookShelfPopToRootPublisher()) { _ in
            isNavigated = false
        }
    }
}

struct BookShelfTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfTabView()
    }
}
