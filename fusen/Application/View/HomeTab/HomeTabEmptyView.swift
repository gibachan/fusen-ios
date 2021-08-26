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
                Spacer().frame(height: 40)
                Text("書籍が登録されていません。")
                HStack(alignment: .center, spacing: 4) {
                    Image.bookShelf
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("タブから登録してください。")
                }
                Image("App")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.placeholder)
                    .opacity(0.4)
                    .frame(width: 112, height: 112)
                    .padding(.top, 8)

            }
            Spacer()
        }
        .font(.medium)
        .foregroundColor(.placeholder)
        .padding(EdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0))
    }
}
