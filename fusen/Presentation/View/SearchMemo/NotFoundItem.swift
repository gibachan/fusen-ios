//
//  NotFoundItem.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import SwiftUI

struct NotFoundItem: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("メモが見つかりませんでした")
                .font(.medium)
                .foregroundColor(.textPrimary)
                .padding(8)
        }
    }
}

struct NotFoundItem_Previews: PreviewProvider {
    static var previews: some View {
        NotFoundItem()
    }
}
