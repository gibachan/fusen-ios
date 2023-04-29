//
//  NotFoundItem.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import SwiftUI

struct NotFoundItem: View {
    var body: some View {
        Text("メモは見つかりませんでした")
            .font(.medium)
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(16)
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
}

struct NotFoundItem_Previews: PreviewProvider {
    static var previews: some View {
        NotFoundItem()
    }
}
