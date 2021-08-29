//
//  BookShelfItem.swift
//  BookShelfItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/15.
//

import SwiftUI

struct BookShelfItem: View {
    let book: Book
    
    @State private var isBookPresented = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            BookImageView(url: book.imageURL)
                .frame(width: 40, height: 60)
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
            
            NavigationLink(isActive: $isBookPresented) {
                LazyView(BookView(bookId: book.id))
            } label: {
                EmptyView()
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .background(Color.white) // Enable to tap empty space
        .onTapGesture {
            isBookPresented = true
        }
    }
}
