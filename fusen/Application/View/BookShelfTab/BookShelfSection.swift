//
//  BookShelfSection.swift
//  BookShelfSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import SwiftUI

struct BookShelfSection: View {
    @StateObject private var viewModel: BookShelfSectionModel
    private let collection: Collection
    
    init(collection: Collection) {
        self._viewModel = StateObject(wrappedValue: BookShelfSectionModel(collection: collection))
        self.collection = collection
    }
    
    var body: some View {
        Section {
            if viewModel.books.isEmpty {
                BookShelfEmptyItem()
            } else {
                ForEach(viewModel.books, id: \.id.value) { book in
                    NavigationLink(destination: LazyView(BookView(book: book))) {
                        BookShelfItem(book: book)
                    }
                }
            }
        } header: {
            HStack {
                SectionHeaderText(viewModel.collection.name)
                Spacer()
                NavigationLink(destination: LazyView(CollectionView(collection: collection))) {
                    ShowAllText()
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

struct BookShelfSection_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfSection(collection: Collection.sample)
    }
}