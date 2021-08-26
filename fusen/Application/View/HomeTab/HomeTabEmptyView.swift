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
                Text("書籍が登録されてません。")
                    .font(.medium)
                    .foregroundColor(.textPrimary)
                HStack(alignment: .center, spacing: 4) {
                    Image.bookShelf
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text("タブから追加してください。")
                        .font(.medium)
                        .foregroundColor(.textPrimary)
                }
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0))
    }
}
