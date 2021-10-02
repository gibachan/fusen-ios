//
//  CollectionView.swift
//  CollectionView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct CollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CollectionViewModel
    @State private var isAddPresented = false
    @State private var isSortPresented = false
    @State private var isDeleteAlertPresented = false
    
    init(collection: Collection) {
        self._viewModel = StateObject(wrappedValue: CollectionViewModel(collection: collection))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
            
            ControlToolbar(
                leadingView: {
                    Image.delete
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                },
                leadingAction: {
                    isDeleteAlertPresented = true
                },
                trailingView: {
                    AddBookIcon()
                },
                trailingAction: {
                    isAddPresented = true
                }
            )
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(viewModel.collection.name, displayMode: .inline)
        .navigationBarItems(trailing: SortButton {
            isSortPresented = true
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
        .actionSheet(isPresented: $isSortPresented) {
            ActionSheet(
                title: Text("書籍をソート"),
                buttons: [
                    .default(Text("作成日時でソート")) {
                        Task {
                            await viewModel.onSort(.createdAt)
                        }
                    },
                    .default(Text("タイトルでソート")) {
                        Task {
                            await viewModel.onSort(.title)
                        }
                    },
                    .default(Text("著者でソート")) {
                        Task {
                            await viewModel.onSort(.author)
                        }
                    },
                    .cancel()
                ]
            )
        }
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loadingNext, .refreshing:
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
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(collection: Collection.sample)
    }
}
