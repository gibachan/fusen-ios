//
//  BookShelfItem.swift
//  BookShelfItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import SwiftUI

struct BookShelfItem: View {
    let book: Book
    var body: some View {
        HStack {
            AsyncImage(url: book.imageURL) { image in
                image
                    .resizable()
            } placeholder: {
                // FIXME: placeholder image
                Color.green
            }
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
}
