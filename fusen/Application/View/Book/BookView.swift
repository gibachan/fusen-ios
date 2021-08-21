//
//  BookView.swift
//  BookView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import SwiftUI

struct BookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: BookViewModel
//    @State private var isFavorite = false
    @State private var isDeleteAlertPresented = false
    @State private var isAddPresented = false
    
    private var book: Book { viewModel.book }
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: BookViewModel(book: book))
        // FIXME: Fetch book by its id
//        self.isFavorite = book.isFavorite
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
        .navigationBarTitle("書籍", displayMode: .inline)
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
                secondaryButton: .destructive(Text("削除"), action: {
                    Task {
                        await viewModel.onDelete()
                    }
                })
            )
        }
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial:
                break
            case .loading:
                LoadingHUD.show()
            case .loadingNext:
                LoadingHUD.dismiss()
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
                        Task {
                            await viewModel.onReadingToggle()
                        }
                    } label: {
                        ReadingMark(isReading: viewModel.isReadingBook)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
//            Toggle(isOn: $isFavorite) {
//                Text("お気に入り")
//                    .font(.medium)
//                    .foregroundColor(.textPrimary)
//            }
//            .listRowSeparator(.visible)
            
            NavigationLink(destination: LazyView(SelectCollectionView(book: book))) {
                Text("コレクション")
                    .font(.medium)
                    .foregroundColor(.textPrimary)
            }
            .listRowSeparator(.visible)
        } header: {
            HStack {
                SectionHeaderText("書籍情報")
                Spacer()
                NavigationLink(destination: Text("書籍詳細")) {
                    ShowAllText()
                }
            }
        }
    }
    
    private var memoSection: some View {
        Section {
            if viewModel.memoPager.data.isEmpty {
                BookEmptyMemoItem()
            } else {
                ForEach(viewModel.memoPager.data, id: \.id.value) { memo in
                    NavigationLink(destination: LazyView(EditMemoView(book: book, memo: memo))) {
                        BookMemoItem(memo: memo)
                            .task {
                                await viewModel.onItemApper(of: memo)
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

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookView(book: Book.sample)
        }
    }
}
