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
                SectionHeaderText("お気に入り")
                Spacer()
                if viewModel.books.isNotEmpty {
                    NavigationLink(destination: LazyView(FavoriteBookListView())) {
                        ShowAllText()
                    }
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
