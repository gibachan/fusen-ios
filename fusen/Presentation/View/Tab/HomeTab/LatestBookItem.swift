//
//  LatestBookItem.swift
//  LatestBookItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import Domain
import SwiftUI

struct LatestBookItem: View {
    let book: Book
    var body: some View {
        HStack(spacing: 8) {
            BookImageView(url: book.imageURL)
                .frame(width: 48, height: 64)
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

struct LatestBookItem_Previews: PreviewProvider {
    static var previews: some View {
        LatestBookItem(book: Book.sample)
    }
}
