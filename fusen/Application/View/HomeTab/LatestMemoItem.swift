//
//  LatestMemoItem.swift
//  LatestMemoItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import SwiftUI

struct LatestMemoItem: View {
    @StateObject private var viewModel: LatestMemoItemModel
    
    private var memo: Memo { viewModel.memo }
    private var book: Book? { viewModel.book }
    
    init(memo: Memo) {
        self._viewModel = StateObject(wrappedValue: LatestMemoItemModel(memo: memo))
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(memo.text)
                    .font(.medium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                Spacer()
                HStack {
                    Text("\(memo.updatedAt.string)")
                        .font(.minimal)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    if let book = book {
                        Text(book.title)
                            .font(.small)
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                    }
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

struct LatestMemoItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LatestMemoItem(memo: Memo.sample)
        }
    }
}