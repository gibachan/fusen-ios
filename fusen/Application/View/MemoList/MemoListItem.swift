//
//  MemoListItem.swift
//  MemoListItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct MemoListItem: View {
    @StateObject var viewModel: MemoListItemModel
    private let memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
        self._viewModel = StateObject(wrappedValue: MemoListItemModel(memo: memo))
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                if !memo.quote.isEmpty {
                    HStack {
                        Text(memo.quote)
                            .font(.medium)
                            .foregroundColor(.textSecondary)
                            .lineLimit(4)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .backgroundColor(.backgroundLightGray)
                    .cornerRadius(4)
                }
                
                Text(memo.text)
                    .font(.medium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(4)
                Spacer()
                
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
                    if !memo.imageURLs.isEmpty {
                        Image.image
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.textSecondary)
                    }
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
