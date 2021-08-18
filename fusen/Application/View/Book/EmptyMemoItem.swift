//
//  EmptyMemoItem.swift
//  EmptyMemoItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import SwiftUI

struct EmptyMemoItem: View {
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

struct EmptyMemoItem_Previews: PreviewProvider {
    static var previews: some View {
        EmptyMemoItem()
    }
}
