//
//  HomeReadingBookItem.swift
//  HomeReadingBookItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import SwiftUI

struct HomeReadingBookItem: View {
    static let height: CGFloat = 56
    let book: Book
    let action: () -> Void
    var body: some View {
        NavigationLink(destination: LazyView(BookView(bookId: book.id))) {
            HStack(alignment: .center) {
                BookImageView(url: book.imageURL)
                    .frame(width: 30, height: 40)
                VStack(alignment: .leading) {
                    Text("読書中")
                        .font(.small)
                        .foregroundColor(.textSecondary)
                    Text(book.title)
                        .font(.small)
                        .lineLimit(1)
                        .foregroundColor(.textPrimary)
                }
                Spacer()
                Image.memo
                    .resizable()
                    .foregroundColor(.active)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        action()
                    }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(height: Self.height)
        .backgroundColor(.white.opacity(0.9))
        .shadow(color: .backgroundGray, radius: 1)
    }
}

struct HomeReadingBookItem_Previews: PreviewProvider {
    static var previews: some View {
        HomeReadingBookItem(book: Book.sample) {}
    }
}
