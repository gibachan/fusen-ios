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
            .frame(width: 32, height: 48)
            Text(book.title)
        }
    }
}
