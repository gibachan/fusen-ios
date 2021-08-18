//
//  MemoItem.swift
//  MemoItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import SwiftUI

struct MemoItem: View {
    let memo: Memo
    var body: some View {
        Text("memo: \(memo.text)")
            .font(.medium)
            .foregroundColor(Color.textPrimary)
    }
}

//struct MemoItem_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoItem()
//    }
//}
