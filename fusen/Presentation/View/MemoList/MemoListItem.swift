//
//  MemoListItem.swift
//  MemoListItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import Domain
import SwiftUI

struct MemoListItem: View {
    @StateObject var viewModel: MemoListItemModel
    private let memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
        self._viewModel = StateObject(wrappedValue: MemoListItemModel(memo: memo))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text("\(memo.updatedAt.string)")
                    .font(.minimal)
                    .foregroundColor(.textSecondary)
                
                Text(viewModel.bookTitle)
                    .font(.minimal)
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
                
                Spacer()
                if let page = memo.page {
                    Text("\(page)ページ")
                        .font(.minimal)
                        .foregroundColor(.textSecondary)
                }
                if memo.imageURLs.isNotEmpty {
                    Image.image
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.bottom, 4)
            
            if memo.quote.isNotEmpty {
                QuoteText(text: memo.quote)
                    .lineLimit(5)
            }
            if memo.text.isNotEmpty {
                Text(memo.text)
                    .font(.medium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(5)
            }
        }
        .padding(.vertical, 4)
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
