//
//  CollectionView.swift
//  CollectionView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct CollectionView: View {
    @StateObject private var viewModel: CollectionViewModel
    @State private var isAddPresented = false
    private let collection: Collection
    
    init(collection: Collection) {
        self._viewModel = StateObject(wrappedValue: CollectionViewModel(collection: collection))
        self.collection = collection
    }
    
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
                    // FIXME: show empty view
                    EmptyView()
                }
            }
            .refreshable {
                await viewModel.onRefresh()
            }
            
            ControlToolbar(
                text: viewModel.textCountText,
                trailingImage: .add,
                trailingAction: {
                    isAddPresented = true
                }
            )
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(collection.name, displayMode: .inline)
        .sheet(isPresented: $isAddPresented) {
            print("dismissed")
        } content: {
            AddBookView()
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

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(collection: Collection.sample)
    }
}
