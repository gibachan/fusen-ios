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
                Spacer()
                HStack {
                    Text("\(memo.updatedAt.string)")
                        .font(.minimal)
                        .foregroundColor(.textSecondary)
                    Spacer()
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
