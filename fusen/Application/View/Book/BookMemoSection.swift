//
//  BookMemoSection.swift
//  BookMemoSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/26.
//

import SwiftUI

struct BookMemoSection: View {
    @StateObject var viewModel: BookMemoSectionModel
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: BookMemoSectionModel(bookId: book.id))
    }
    
    var body: some View {
        Section {
            if viewModel.memoPager.data.isEmpty {
                BookEmptyMemoItem()
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
            SectionHeaderText("メモ")
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

struct BookMemoSection_Previews: PreviewProvider {
    static var previews: some View {
        BookMemoSection(book: Book.sample)
    }
}
