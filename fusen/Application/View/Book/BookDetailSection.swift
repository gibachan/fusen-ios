//
//  BookDetailSection.swift
//  BookDetailSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/26.
//

import SwiftUI

struct BookDetailSection: View {
    private let book: Book
    private let isReadingBook: Bool
    private let readingToggleAction: () -> Void
    private let favoriteChangeAction: (Bool) -> Void
    @State private var isFavorite: Bool
    @Binding private var isDetailCollapsed: Bool
    
    init(
        book: Book,
        isReadingBook: Bool,
        isFavorite: Bool,
        readingToggleAction: @escaping () -> Void,
        favoriteChangeAction: @escaping (Bool) -> Void,
        isDetailCollapsed: Binding<Bool>
    ) {
        self.book = book
        self.isReadingBook = isReadingBook
        self._isFavorite = State(wrappedValue: isFavorite)
        self.readingToggleAction = readingToggleAction
        self.favoriteChangeAction = favoriteChangeAction
        self._isDetailCollapsed = isDetailCollapsed
    }
    
    var body: some View {
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
            .onTapGesture {
                withAnimation {
                    isDetailCollapsed.toggle()
                }
            }
            
            if !isDetailCollapsed {
//                Toggle(isOn: $isFavorite) {
//                    Text("お気に入り")
//                        .font(.medium)
//                        .foregroundColor(.textPrimary)
//                }
//                .onChange(of: isFavorite, perform: { newValue in
//                    favoriteChangeAction(newValue)
//                })
//                .listRowSeparator(.visible)
                
                NavigationLink(destination: LazyView(SelectCollectionView(book: book))) {
                    Text("コレクション")
                        .font(.medium)
                        .foregroundColor(.textPrimary)
                }
                .listRowSeparator(.visible)

                NavigationLink(destination: LazyView(EditBookView(book: book))) {
                    Text("情報を編集")
                        .font(.medium)
                        .foregroundColor(.textPrimary)
                }
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
}

struct BookDetailSection_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailSection(book: Book.sample, isReadingBook: false, isFavorite: false, readingToggleAction: {}, favoriteChangeAction: { _ in }, isDetailCollapsed: Binding<Bool>.constant(false))
    }
}
