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
                Text(memo.text)
                    .font(.medium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(4)
                
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

                Spacer()
                
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
    }
}

struct BookMemoItem_Previews: PreviewProvider {
    static var previews: some View {
        BookMemoItem(memo: Memo.sample)
    }
}
