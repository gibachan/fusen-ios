//
//  BookShelfFavoriteSection.swift
//  BookShelfFavoriteSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/22.
//

import SwiftUI

struct BookShelfFavoriteSection: View {
    @StateObject private var viewModel = BookShelfFavoriteSectionModel()
    
    var body: some View {
        Section {
            if viewModel.books.isEmpty {
                BookShelfEmptyItem()
            } else {
                ForEach(viewModel.books, id: \.id.value) { book in
                    NavigationLink(destination: LazyView(BookView(bookId: book.id))) {
                        BookShelfItem(book: book)
                    }
                }
            }
        } header: {
            HStack {
                SectionHeaderText("お気に入り")
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

struct BookShelfFavoriteSection_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfFavoriteSection()
    }
}
