//
//  BookShelfEmptyItem.swift
//  BookShelfEmptyItem
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct BookShelfEmptyItem: View {
    var body: some View {
        HStack {
            Spacer()
            Text("書籍が登録されていません。")
                .font(.medium)
                .foregroundColor(.placeholder)
            Spacer()
        }
        .frame(minHeight: 64)
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
}

struct BookShelfEmptyItem_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfEmptyItem()
    }
}
