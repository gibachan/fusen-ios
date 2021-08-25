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
                SectionHeaderText("すべての書籍")
                Spacer()
                NavigationLink(destination: LazyView(BookListView())) {
                    ShowAllText()
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
        .onReceive(NotificationCenter.default.refreshBookShelfPublisher()) { _ in
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
