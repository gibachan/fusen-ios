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
        HStack(alignment: .top, spacing: 8) {
            BookImageView(url: book.imageURL)
                .frame(width: 48)
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.minimal)
                    .fontWeight(.bold)
                    .lineLimit(3)
                    .foregroundColor(.textSecondary)
                Spacer(minLength: 8)
                Text(book.author)
                    .font(.minimal)
                    .lineLimit(1)
                    .foregroundColor(.textSecondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 72)
        .backgroundColor(.white) // Enable to tap empty space
    }
}
