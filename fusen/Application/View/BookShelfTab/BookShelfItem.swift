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
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Spacer()
                BookImageView(url: book.imageURL)
                    .frame(width: 40, height: 60)
                Spacer()
            }
            Text(book.title)
                .font(.minimal)
                .lineLimit(3)
                .foregroundColor(.textSecondary)
            
            NavigationLink(isActive: $isBookPresented) {
                LazyView(BookView(bookId: book.id))
            } label: {
                EmptyView()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 100)
        .onTapGesture {
            isBookPresented = true
        }
    }
}
