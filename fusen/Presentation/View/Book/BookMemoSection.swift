//
//  BookMemoSection.swift
//  BookMemoSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/26.
//

import SwiftUI

struct BookMemoSection: View {
    @StateObject private var viewModel: BookMemoSectionModel
    @State private var isSortPresented = false
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: BookMemoSectionModel(bookId: book.id))
    }
    
    var body: some View {
        Section {
            if viewModel.memoPager.data.isEmpty {
                BookEmptyMemoItem()
                    .listRowSeparator(.hidden)
            } else {
                ForEach(viewModel.memoPager.data, id: \.id.value) { memo in
                    NavigationLink(destination: LazyView(EditMemoView(memo: memo))) {
                        BookMemoItem(memo: memo)
                            .onAppear {
                                Task {
                                    await viewModel.onItemApper(of: memo)
                                }
                            }
                    }
                }
            }
        } header: {
            HStack {
                SectionHeaderText("メモ")
                Spacer()
                SortButton {
                    isSortPresented = true
                }
                .frame(width: 22, height: 18)
            }
        }
        .task {
            await viewModel.onAppear()
        }
        .actionSheet(isPresented: $isSortPresented) {
            ActionSheet(
                title: Text("メモをソート"),
                buttons: [
                    .default(Text("作成日時でソート")) {
                        Task {
                            await viewModel.onSort(.createdAt)
                        }
                    },
                    .default(Text("ページでソート")) {
                        Task {
                            await viewModel.onSort(.page)
                        }
                    },
                    .cancel()
                ]
            )
        }
    }
}

struct BookMemoSection_Previews: PreviewProvider {
    static var previews: some View {
        BookMemoSection(book: Book.sample)
    }
}
