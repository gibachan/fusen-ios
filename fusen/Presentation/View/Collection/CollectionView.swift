//
//  CollectionView.swift
//  CollectionView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import Domain
import SwiftUI

struct CollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CollectionViewModel
    @State private var isAddPresented = false
    @State private var isSortPresented = false
    @State private var isDeleteAlertPresented = false
    @State private var displayStyle: DisplayStyle = .list

    init(collection: Domain.Collection) {
        self._viewModel = StateObject(wrappedValue: CollectionViewModel(collection: collection))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch displayStyle {
            case .list:
                listStyleView
            case .grid:
                gridStyleView
            }

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
                    AddBookIcon()
                        .onTapGesture {
                            isAddPresented = true
                        }
                }
            )
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(viewModel.collection.name, displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            DisplyStyleButton {
                withAnimation {
                    displayStyle = displayStyle.next()
                }
            }
            SortButton {
                isSortPresented = true
            }
        })
        .sheet(isPresented: $isAddPresented) {
            Task {
                await viewModel.onRefresh()
            }
        } content: {
            AddBookMenuView(in: viewModel.collection)
        }
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("コレクションを削除"),
                message: Text("コレクションを削除しても、コレクションに設定された書籍は削除されません。コレクションを削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("削除"), action: {
                    Task {
                        await viewModel.onDelete()
                    }
                })
            )
        }
        .confirmationDialog("書籍をソート", isPresented: $isSortPresented, titleVisibility: .visible) {
            Button(action: {
                Task {
                    await viewModel.onSort(.createdAt)
                }
            }, label: {
                if viewModel.sortedBy == .createdAt {
                    Text("\(String.checkMark)作成日時でソート")
                } else {
                    Text("作成日時でソート")
                }
            })
            Button(action: {
                Task {
                    await viewModel.onSort(.title)
                }
            }, label: {
                if viewModel.sortedBy == .title {
                    Text("\(String.checkMark)タイトルでソート")
                } else {
                    Text("タイトルでソート")
                }
            })
            Button(action: {
                Task {
                    await viewModel.onSort(.author)
                }
            }, label: {
                if viewModel.sortedBy == .author {
                    Text("\(String.checkMark)著者でソート")
                } else {
                    Text("著者でソート")
                }
            })
            Button("キャンセル", role: .cancel, action: {})
        }
        .loading(viewModel.state == .loading)
        .task {
            await viewModel.onAppear()
        }
    }
}

private extension CollectionView {
    enum DisplayStyle {
        case list, grid

        func next() -> DisplayStyle {
            switch self {
            case .list: return .grid
            case .grid: return .list
            }
        }
    }

    var listStyleView: some View {
        List {
            ForEach(viewModel.pager.data, id: \.id.value) { book in
                NavigationLink(destination: LazyView(BookView(bookId: book.id))) {
                    BookListItem(book: book)
                        .task {
                            await viewModel.onItemApper(of: book)
                        }
                }
            }
            if viewModel.pager.data.isEmpty {
                BookShelfEmptyItem()
                    .listRowSeparator(.hidden)
            }
        }
        .refreshable {
            await viewModel.onRefresh()
        }
    }

    var gridStyleView: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 48), spacing: 16), count: 3), alignment: .leading, spacing: 16) {
                ForEach(viewModel.pager.data, id: \.id.value) { book in
                    NavigationLink(destination: LazyView(BookView(bookId: book.id))) {
                        BookGridItem(book: book)
                            .task {
                                await viewModel.onItemApper(of: book)
                            }
                    }
                }
            }
            .padding(16)
        }
        .overlay(
            Group {
                if viewModel.pager.data.isEmpty {
                    ZStack(alignment: .center) {
                        Text("書籍が登録されていません。")
                            .font(.medium)
                            .foregroundColor(.placeholder)
                    }
                }
            }
        )
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(collection: Collection.sample)
    }
}
