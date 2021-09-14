//
//  BookMemoItem.swift
//  BookMemoItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import SwiftUI

struct BookMemoItem: View {
    let memo: Memo
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("\(memo.updatedAt.string)")
                        .font(.minimal)
                        .foregroundColor(.textSecondary)
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
                if memo.quote.isNotEmpty {
                    QuoteText(text: memo.quote)
                        .lineLimit(6)
                }
                if memo.text.isNotEmpty {
                    Text(memo.text)
                        .font(.medium)
                        .foregroundColor(.textPrimary)
                        .lineLimit(6)
                }
            }
        }
    }
}

struct BookMemoItem_Previews: PreviewProvider {
    static var previews: some View {
        BookMemoItem(memo: Memo.sample)
    }
}
