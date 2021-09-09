//
//  BookShelfAllSection.swift
//  BookShelfAllSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/22.
//

import SwiftUI

struct BookShelfAllSection: View {
    @StateObject private var viewModel = BookShelfAllSectionModel()
    
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
                    .padding(.vertical, 4)
                }
            }
        } header: {
            HStack {
                SectionHeaderText("すべての書籍")
                Spacer()
                if viewModel.bookColumns.isNotEmpty {
                    NavigationLink(destination: LazyView(BookListView())) {
                        ShowAllText()
                    }
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
        .onReceive(NotificationCenter.default.refreshBookShelfAllCollectionPublisher()) { _ in
            Task {
                await viewModel.onRefresh()
            }
        }
    }
}

struct BookShelfAllSection_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfAllSection()
    }
}
