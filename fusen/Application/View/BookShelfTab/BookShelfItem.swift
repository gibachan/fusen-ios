//
//  BookShelfItem.swift
//  BookShelfItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import SwiftUI

struct BookShelfItem: View {
    @StateObject private var viewModel: BookShelfItemModel
    
    init(bookId: ID<Book>) {
        self._viewModel = StateObject(wrappedValue: BookShelfItemModel(bookId: bookId))
    }
    
    var body: some View {
        Group {
            if let book = viewModel.book {
                NavigationLink(destination: LazyView(BookView(book: book))) {
                    HStack {
                        BookImageView(url: book.imageURL)
                            .frame(width: 40, height: 60)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(book.title)
                                .font(.small)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .foregroundColor(.textSecondary)
                            Spacer(minLength: 8)
                            Text(book.author)
                                .font(.small)
                                .lineLimit(1)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            } else {
                Text("Loading")
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
}
