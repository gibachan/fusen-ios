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
            if viewModel.bookColumns.isEmpty {
                BookShelfEmptyItem()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(viewModel.bookColumns) { column in
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(column.books, id: \.id) { book in
                                    BookShelfItem(book: book)
                                    if book.id != column.books.last?.id {
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
                if viewModel.bookColumns.isNotEmpty {
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
