//
//  HomeTabEmptyView.swift
//  HomeTabEmptyView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/26.
//

import SwiftUI

struct HomeTabEmptyView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                Text("書籍が登録されていません。")
                HStack(alignment: .center, spacing: 4) {
                    Image.bookShelf
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("タブから追加してください。")
                }
            }
            Spacer()
        }
        .font(.medium)
        .foregroundColor(.placeholder)
        .padding(EdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0))
    }
}
