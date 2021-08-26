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
                BookShelfFavoriteSection()
                ForEach(viewModel.collections, id: \.id.value) { collection in
                    BookShelfCollectionSection(collection: collection)
                }
                BookShelfAllSection()
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
                    
                },
                leadingAction: {
                    isAddCollectionPresented = true
                },
                trailingView: {
                    Image.add
                        .resizable()
                        .frame(width: 24, height: 24)
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
                //                isErrorActive = true
            }
        }
        .onReceive(NotificationCenter.default.refreshBookShelfPublisher()) { _ in
            Task {
                await viewModel.onRefresh()
            }
        }
    }
}

struct BookShelfTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfTabView()
    }
}
