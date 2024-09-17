//
//  BookShelfAllSection.swift
//  BookShelfAllSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/22.
//

import SwiftUI

struct BookShelfAllSection: View {
    @StateObject private var viewModel = BookShelfAllSectionModel()
    @Binding var isNavigated: Bool
    @Binding var navigation: BookShelfNavigation

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
                                    Button {
                                        navigate(to: .book(book: book))
                                    } label: {
                                        BookShelfItem(book: book)
                                    }
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
                    Button {
                        navigate(to: .allBooks)
                    } label: {
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

extension BookShelfAllSection {
    private func navigate(to navigation: BookShelfNavigation) {
        self.navigation = navigation
        self.isNavigated = true
    }
}

struct BookShelfAllSection_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfAllSection(isNavigated: Binding<Bool>.constant(false), navigation: Binding<BookShelfNavigation>.constant(.none))
    }
}
