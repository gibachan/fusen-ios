//
//  BookShelfCollectionSection.swift
//  BookShelfCollectionSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import SwiftUI

struct BookShelfCollectionSection: View {
    @StateObject private var viewModel: BookShelfCollectionSectionModel
    private let collection: Collection
    
    init(collection: Collection) {
        self._viewModel = StateObject(wrappedValue: BookShelfCollectionSectionModel(collection: collection))
        self.collection = collection
    }
    
    var body: some View {
        Section {
            if viewModel.books.isEmpty {
                BookShelfEmptyItem()
                    .listRowSeparator(.hidden)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(0..<viewModel.books.count) { columnIndex in
                            let booksColumn = viewModel.books[columnIndex]
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(0..<booksColumn.count) { index in
                                    let book = booksColumn[index]
                                    BookShelfItem(book: book)
                                    if index < booksColumn.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                            .frame(width: 200)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        } header: {
            HStack {
                Image.collection
                    .resizable()
                    .frame(width: 20, height: 18)
                    .foregroundColor(Color(rgb: viewModel.collection.color))
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

struct BookShelfCollectionSection_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfCollectionSection(collection: Collection.sample)
    }
}
