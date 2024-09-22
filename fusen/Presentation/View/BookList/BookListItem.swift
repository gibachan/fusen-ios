//
//  BookListItem.swift
//  BookListItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import Domain
import SwiftUI

struct BookListItem: View {
    let book: Book

    var body: some View {
        HStack {
            BookImageView(url: book.imageURL)
                .frame(width: 48)
            VStack(alignment: .leading, spacing: 0) {
                Text(book.title)
                    .font(.small)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.textSecondary)
                Spacer(minLength: 8)
                Text(book.author)
                    .font(.small)
                    .lineLimit(1)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

struct BookListItem_Previews: PreviewProvider {
    static var previews: some View {
        BookListItem(book: Book.sample)
    }
}
