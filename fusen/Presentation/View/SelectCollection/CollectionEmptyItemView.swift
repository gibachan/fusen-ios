//
//  CollectionEmptyItemView.swift
//  CollectionEmptyItemView
//
//  Created by Tatsuyuki Kobayashi on 2021/09/15.
//

import SwiftUI

struct CollectionEmptyItemView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("コレクションが登録されていません。")
                .font(.medium)
                .foregroundColor(.placeholder)
            Spacer()
        }
        .frame(minHeight: 64)
    }
}

struct CollectionEmptyItemView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionEmptyItemView()
    }
}
