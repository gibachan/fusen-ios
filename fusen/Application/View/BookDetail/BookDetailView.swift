//
//  BookDetailView.swift
//  BookDetailView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import SwiftUI

struct BookDetailView: View {
    @StateObject var viewModel = BookDetailViewModel()
    @State var impression: String = ""
    @State var isFavorite: Bool = false
    
    let book: Book
    
    init(book: Book) {
        self.book = book
        self.impression = book.impression
        self.isFavorite = book.isFavorite
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                BookImageView(url: book.imageURL)
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
                Spacer()
            }
            .frame(height: 60)
            .padding()
            
            List {
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        PlaceholderTextEditor(placeholder: "感想を入力", text: $impression)
                            .frame(minHeight: 40)
                            .font(.medium)
                            .foregroundColor(.textSecondary)
                    }
                    //
                    Toggle(isOn: $isFavorite) {
                        Text("お気に入り")
                    }
                }
                Button {
                    Task {
                        await viewModel.onUpdate()
                    }
                } label: {
                    Text("更新")
                        .font(.medium)
                }
                Button(role: .destructive) {
                    Task {
                        await viewModel.onDelete()
                    }
                } label: {
                    Text("削除")
                        .font(.medium)
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookDetailView(book: Book.sample)
        }
    }
}
