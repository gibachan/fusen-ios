//
//  BookContentView.swift
//  BookContentView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import SwiftUI

struct BookContentView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isDetailCollapsed = true
    @State private var isDeleteAlertPresented = false
    @State private var isAddPresented = false
    @State private var isFavorite: Bool
    
    let book: Book
    let isReadingBook: Bool
    let memos: [Memo]
    let memoItemAppearAction: (Memo) -> Void
    let readingToggleAction: () -> Void
    let favoriteChangeAction: (Bool) -> Void
    let deleteActin: () -> Void
    
    init(
        book: Book,
        isReadingBook: Bool,
        memos: [Memo],
        memoItemAppearAction: @escaping (Memo) -> Void,
        readingToggleAction: @escaping () -> Void,
        favoriteChangeAction: @escaping (Bool) -> Void,
        deleteAction: @escaping () -> Void
    ) {
        self.book = book
        self.isReadingBook = isReadingBook
        self.memos = memos
        self.memoItemAppearAction = memoItemAppearAction
        self.readingToggleAction = readingToggleAction
        self.favoriteChangeAction = favoriteChangeAction
        self.deleteActin = deleteAction
        
        self._isFavorite = State(wrappedValue: book.isFavorite)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                bookDetailSection
                    .listRowSeparator(.hidden)
                
                memoSection
                    .padding(.bottom, 16)
                
                buttonSection
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            
            ControlToolbar(
                trailingImage: .memo,
                trailingAction: {
                    isAddPresented = true
                }
            )
        }
        .fullScreenCover(isPresented: $isAddPresented) {
            print("dismissed")
        } content: {
            NavigationView {
                AddMemoView(book: book)
            }
        }
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("書籍を削除"),
                message: Text("書籍を削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("削除"), action: deleteActin)
            )
        }
    }
    
    private var bookDetailSection: some View {
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
                    Button {
                        readingToggleAction()
                    } label: {
                        ReadingMark(isReading: isReadingBook)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if !isDetailCollapsed {
                Toggle(isOn: $isFavorite) {
                    Text("お気に入り")
                        .font(.medium)
                        .foregroundColor(.textPrimary)
                }
                .onChange(of: isFavorite, perform: { newValue in
                    favoriteChangeAction(newValue)
                })
                .listRowSeparator(.visible)
                
                NavigationLink(destination: LazyView(SelectCollectionView(book: book))) {
                    Text("コレクション")
                        .font(.medium)
                        .foregroundColor(.textPrimary)
                }
                .listRowSeparator(.visible)
            }
        } header: {
            HStack {
                SectionHeaderText("書籍情報")
                Spacer()
                Button {
                    withAnimation {
                        isDetailCollapsed.toggle()
                    }
                } label: {
                    Image.chevronRight
                        .resizable()
                        .foregroundColor(.active)
                        .frame(width: 12, height: 18)
                        .rotationEffect(Angle(degrees: isDetailCollapsed ? 0 : 90))
                }

            }
        }
    }
    
    private var memoSection: some View {
        Section {
            if memos.isEmpty {
                BookEmptyMemoItem()
            } else {
                ForEach(memos, id: \.id.value) { memo in
                    NavigationLink(destination: LazyView(EditMemoView(memo: memo))) {
                        BookMemoItem(memo: memo)
                            .onAppear {
                                memoItemAppearAction(memo)
                            }
                    }
                }
            }
        } header: {
            SectionHeaderText("メモ")
        }
    }
    
    private var buttonSection: some View {
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
    }
}

struct BookContentView_Previews: PreviewProvider {
    static var previews: some View {
        BookContentView(book: Book.sample, isReadingBook: true, memos: [Memo.sample], memoItemAppearAction: { _ in }, readingToggleAction: {}, favoriteChangeAction: { _ in }, deleteAction: {})
    }
}
