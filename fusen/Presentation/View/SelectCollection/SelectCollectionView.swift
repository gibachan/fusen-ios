//
//  SelectCollectionView.swift
//  SelectCollectionView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import Domain
import SwiftUI

struct SelectCollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SelectCollectionViewModel
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: SelectCollectionViewModel(book: book))
    }
    
    var body: some View {
        List {
            if viewModel.collections.isEmpty {
                CollectionEmptyItemView()
            } else {
                ForEach(viewModel.collections, id: \.name) { collection in
                    CollectionItemView(collection: collection, isSelected: viewModel.book.collectionId == collection.id)
                        .onTapGesture {
                            Task {
                                await viewModel.onSelect(collection: collection)
                            }
                        }
                }
            }
        }
        .navigationTitle("コレクション")
        .loading(viewModel.state == .loading)
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loading, .loaded, .failed:
                break
            case .updated:
                dismiss()
            }
        }
    }
}

struct SelectCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCollectionView(book: Book.sample)
    }
}
