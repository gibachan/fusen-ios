//
//  MemoListItem.swift
//  MemoListItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct MemoListItem: View {
    @StateObject var viewModel: MemoListItemModel
    
    init(memo: Memo) {
        self._viewModel = StateObject(wrappedValue: MemoListItemModel(memo: memo))
    }
    
    var body: some View {
        Group {
            if let book = viewModel.book {
                NavigationLink(destination: LazyView(EditMemoView(book: book, memo: viewModel.memo))) {
                    VStack(alignment: .leading) {
                        Text("memo: \(viewModel.memo.text)")
                            .font(.medium)
                            .foregroundColor(Color.textPrimary)
                        Text("book: \(book.title)")
                    }
                }
            } else {
                VStack(alignment: .leading) {
                    Text("memo: \(viewModel.memo.text)")
                        .font(.medium)
                        .foregroundColor(Color.textPrimary)
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

struct MemoListItem_Previews: PreviewProvider {
    static var previews: some View {
        MemoListItem(memo: Memo.sample)
    }
}
