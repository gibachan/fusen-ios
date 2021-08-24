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
                    HStack(alignment: .top, spacing: 24) {
                        ForEach(viewModel.books, id: \.id.value) { book in
                            BookShelfItem(book: book)
                        }
                    }
                    .padding(.vertical, 8)
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
