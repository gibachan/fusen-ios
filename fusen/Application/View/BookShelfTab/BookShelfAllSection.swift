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
    }
}

struct BookShelfAllSection_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfAllSection()
    }
}
