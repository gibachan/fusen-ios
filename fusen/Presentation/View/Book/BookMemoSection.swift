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
        .confirmationDialog("メモをソート", isPresented: $isSortPresented, titleVisibility: .visible) {
            Button {
                Task {
                    await viewModel.onSort(.createdAt)
                }
            } label: {
                if viewModel.sortedBy == .createdAt {
                    Text("\(String.checkMark)作成日時でソート")
                } else {
                    Text("作成日時でソート")
                }
            }
            Button {
                Task {
                    await viewModel.onSort(.page)
                }
            } label: {
                if viewModel.sortedBy == .page {
                    Text("\(String.checkMark)ページでソート")
                } else {
                    Text("ページでソート")
                }
            }
            Button("キャンセル", role: .cancel, action: {})
        }
    }
}

struct BookMemoSection_Previews: PreviewProvider {
    static var previews: some View {
        BookMemoSection(book: Book.sample)
    }
}
