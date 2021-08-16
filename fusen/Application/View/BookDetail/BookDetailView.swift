//
//  BookDetailView.swift
//  BookDetailView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import SwiftUI

struct BookDetailView: View {
    @StateObject var viewModel: BookDetailViewModel
    @State var isFavorite: Bool = false
    
    private var book: Book { viewModel.book }
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
        self.isFavorite = book.isFavorite
    }
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
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
                    Divider()
                }
                
                Toggle(isOn: $isFavorite) {
                    Text("お気に入り")
                }
                .listRowSeparator(.visible)
                .onChange(of: isFavorite, perform: { newValue in
                    log.d("HIT: \(newValue)")
                })
                
                NavigationLink(destination: Text("カテゴリ")) {
                    Text("カテゴリ")
                }
                .listRowSeparator(.visible)
            } header: {
                HStack {
                    Text("書籍情報")
                        .font(.medium)
                        .fontWeight(.bold)
                    Spacer()
                    NavigationLink(destination: Text("書籍詳細")) {
                        Text("すべて表示")
                            .font(.medium)
                    }
                }
            }
            .listRowSeparator(.hidden)
            
            Spacer()
                .frame(height: 16)
                .listRowSeparator(.hidden)
            
            Section {
                Text("メモを追加")
            } header: {
                HStack {
                    Text("メモ")
                        .font(.medium)
                        .fontWeight(.bold)
                }
            }
            .listRowSeparator(.hidden)
            
            Spacer()
                .frame(height: 16)
                .listRowSeparator(.hidden)
            
            Section {
                HStack {
                    Spacer()
                    Button(role: .destructive) {
                        Task {
                            await viewModel.onDelete()
                        }
                    } label: {
                        Text("削除")
                            .font(.medium)
                    }
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("書籍", displayMode: .inline)
        //        .navigationBarItems(trailing: favoriteButton)
    }
    
    //    private var favoriteButton: some View {
    //        Button {
    //            // TODO: Implement
    //        } label: {
    //            Image.nonFavorite
    //                .resizable()
    //                .frame(width: 24, height: 24)
    //                .foregroundColor(isFavorite ? .favorite : .inactive)
    //        }
    //    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookDetailView(book: Book.sample)
        }
    }
}
