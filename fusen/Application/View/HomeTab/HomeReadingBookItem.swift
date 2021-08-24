//
//  HomeReadingBookItem.swift
//  HomeReadingBookItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import SwiftUI

struct HomeReadingBookItem: View {
    static let height: CGFloat = 72
    let book: Book
    let action: () -> Void
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("読書中の書籍")
                    .font(.small)
                    .fontWeight(.bold)
                    .foregroundColor(.textSecondary)
                HStack(alignment: .center) {
                    BookImageView(url: book.imageURL)
                        .frame(width: 30, height: 40)
                    Text(book.title)
                        .font(.small)
                        .lineLimit(2)
                        .foregroundColor(.textSecondary)
                    
                }
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
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .border(Color.backgroundGray, width: 0.5)
        .frame(height: Self.height)
        .background(Color.white.opacity(0.9))
    }
}

struct HomeReadingBookItem_Previews: PreviewProvider {
    static var previews: some View {
        HomeReadingBookItem(book: Book.sample) {}
    }
}
