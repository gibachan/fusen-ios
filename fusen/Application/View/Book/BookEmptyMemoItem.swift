//
//  BookEmptyMemoItem.swift
//  BookEmptyMemoItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import SwiftUI

struct BookEmptyMemoItem: View {
    var body: some View {
        HStack {
            Spacer()
            Text("メモはまだありません")
                .font(.medium)
                .foregroundColor(.textPrimary)
            Spacer()
        }
    }
}

struct BookEmptyMemoItem_Previews: PreviewProvider {
    static var previews: some View {
        BookEmptyMemoItem()
    }
}
