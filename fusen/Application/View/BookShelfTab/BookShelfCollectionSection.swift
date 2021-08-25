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
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(viewModel.books, id: \.id.value) { book in
                            BookShelfItem(book: book)
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
