//
//  MemoListItem.swift
//  MemoListItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct MemoListItem: View {
    let memo: Memo
    var body: some View {
        Text("memo: \(memo.text)")
            .font(.medium)
            .foregroundColor(Color.textPrimary)
    }
}

struct MemoListItem_Previews: PreviewProvider {
    static var previews: some View {
        MemoListItem(memo: Memo.sample)
    }
}
