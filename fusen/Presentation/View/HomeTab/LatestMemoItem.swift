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
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("\(memo.updatedAt.string)")
                        .font(.minimal)
                        .foregroundColor(.textSecondary)
                    if let book = book {
                        Text(book.title)
                            .font(.small)
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    if let page = memo.page {
                        Text("\(page)ページ")
                            .font(.minimal)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(.bottom, 4)
                
                if memo.quote.isNotEmpty {
                    QuoteText(text: memo.quote)
                        .lineLimit(2)
                }
                if memo.text.isNotEmpty {
                    Text(memo.text)
                        .font(.medium)
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 4)
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
