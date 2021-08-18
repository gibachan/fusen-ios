//
//  BookShelfSection.swift
//  BookShelfSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import SwiftUI

struct BookShelfSection: View {
    @StateObject private var viewModel: BookShelfSectionModel
    
    init(collection: Collection) {
        self._viewModel = StateObject(wrappedValue: BookShelfSectionModel(collection: collection))
    }
    
    var body: some View {
        Section {
            ForEach(viewModel.bookIds, id: \.value) { bookId in
//                NavigationLink(destination: LazyView(BookView(book: book))) {
                    BookShelfItem(bookId: bookId)
//                }
            }
        } header: {
            HStack {
                SectionHeaderText(viewModel.collection.name)
                Spacer()
                NavigationLink(destination: LazyView(BookListView())) {
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
