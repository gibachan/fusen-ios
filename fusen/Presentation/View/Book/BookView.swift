//
//  BookView.swift
//  BookView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import Domain
import SwiftUI

struct BookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: BookViewModel

    @State private var isDetailCollapsed = false
    @State private var isAddPresented = false
    @State private var isDeleteAlertPresented = false
    @State private var isErrorActive = false

    init(bookId: ID<Book>) {
        self._viewModel = StateObject(wrappedValue: BookViewModel(bookId: bookId))
    }

    var body: some View {
        ZStack {
            if case let .loaded(book) = viewModel.state {
                VStack(alignment: .leading, spacing: 0) {
                    List {
                        BookDetailSection(
                            book: book,
                            isReadingBook: viewModel.isReadingBook,
                            isFavorite: viewModel.isFavorite,
                            readingToggleAction: {
                                Task {
                                    await viewModel.onReadingToggle()
                                }
                            },
                            favoriteChangeAction: { newValue in
                                Task {
                                    await viewModel.onFavoriteChange(isFavorite: newValue)
                                }
                            },
                            isDetailCollapsed: $isDetailCollapsed
                        )
                            .listRowSeparator(.hidden)

                        BookMemoSection(book: book)
                    }
                    .listStyle(PlainListStyle())

                    ControlToolbar(
                        leadingView: {
                            Image.delete
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                                .onTapGesture {
                                    isDeleteAlertPresented = true
                                }
                        },
                        trailingView: {
                            Image.memo
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.active)
                                .onTapGesture {
                                    isAddPresented = true
                                }
                        }
                    )
                }
                .sheet(isPresented: $isAddPresented) {
                    Task {
                        await viewModel.onRefresh()
                    }
                } content: {
                    NavigationView {
                        AddMemoView(book: book)
                    }
                }
                .alert(isPresented: $isDeleteAlertPresented) {
                    Alert(
                        title: Text("書籍を削除"),
                        message: Text("書籍と共に関連するデータをすべて削除します。書籍を削除しますか？"),
                        primaryButton: .cancel(Text("キャンセル")),
                        secondaryButton: .destructive(Text("削除"), action: {
                            Task {
                                await viewModel.onDelete()
                            }
                        })
                    )
                }
            }

            if viewModel.isEmpty {
                BookEmptyView()
            }
        }
        .navigationBarTitle("書籍", displayMode: .inline)
        .loading(viewModel.isLoading)
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loading, .loaded, .failed:
                break
            case .deleted:
                LoadingHUD.dismiss()
                dismiss()
            }
        }
        .onReceive(NotificationCenter.default.refreshBookShelfAllCollectionPublisher()) { _ in
            Task {
                await viewModel.onRefresh()
            }
        }
        .onReceive(NotificationCenter.default.newMemoAddedViaDeepLinkPublisher()) { _ in
            Task {
                await viewModel.onRefresh()
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookView(bookId: Book.sample.id)
        }
    }
}
