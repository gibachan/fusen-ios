//
//  BookDetailView.swift
//  BookDetailView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import SwiftUI

struct BookDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: BookDetailViewModel
    @State var isFavorite = false
    @State var isDeleteAlertPresented = false
    
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
                        isDeleteAlertPresented = true
                    } label: {
                        Text("削除")
                            .font(.medium)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("書籍", displayMode: .inline)
        //        .navigationBarItems(trailing: favoriteButton)
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("書籍を削除"),
                message: Text("書籍を削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("削除"), action: {
                    Task {
                        await viewModel.onDelete()
                    }
                })
            )
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial:
                break
            case .loading:
                LoadingHUD.show()
            case .succeeded:
                LoadingHUD.dismiss()
            case .deleted:
                LoadingHUD.dismiss()
                dismiss()
            case .failed:
                LoadingHUD.dismiss()
                //                isErrorActive = true
            }
        }
        
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
