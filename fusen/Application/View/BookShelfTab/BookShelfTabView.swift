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
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                BookShelfAllSection()
                if viewModel.isFavoriteVisible {
                    BookShelfFavoriteSection()
                }
                ForEach(viewModel.collections, id: \.id.value) { collection in
                    BookShelfCollectionSection(collection: collection)
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                await viewModel.onRefresh()
            }
            
            ControlToolbar(
                leadingView: {
                    Image.addCollection
                        .resizable()
                        .frame(width: 28, height: 24)
                        .foregroundColor(.active)
                    
                },
                leadingAction: {
                    isAddCollectionPresented = true
                },
                trailingView: {
                    addBooKIcon
                },
                trailingAction: {
                    isAddBookPresented = true
                }
            )
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("本棚")
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

extension BookShelfTabView {
    private var addBooKIcon: some View {
        Image.book
            .resizable()
            .frame(width: 20, height: 24)
            .overlay {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 15, height: 15)
                    .offset(x: 8, y: -8)
            }
            .overlay {
                Image.addCircle
                    .resizable()
                    .frame(width: 12, height: 12)
                    .background(Color.white)
                    .offset(x: 8, y: -8)
            }
            .foregroundColor(.active)
    }
}

struct BookShelfTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfTabView()
    }
}
