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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
//                Spacer()
                BookImageView(url: book.imageURL)
                    .frame(width: 40, height: 60)
                Spacer()
            }
            Text(book.title)
                .font(.small)
                .fontWeight(.bold)
                .lineLimit(2)
                .foregroundColor(.textSecondary)
            
            NavigationLink(isActive: $isBookPresented) {
                LazyView(BookView(bookId: book.id))
            } label: {
                EmptyView()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 120)
        .onTapGesture {
            isBookPresented = true
        }
    }
}
