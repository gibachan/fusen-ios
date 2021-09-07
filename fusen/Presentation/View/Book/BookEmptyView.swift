//
//  BookEmptyView.swift
//  BookEmptyView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/21.
//

import SwiftUI

struct BookEmptyView: View {
    var body: some View {
        Text("書籍情報を取得できません")
            .font(.medium)
            .foregroundColor(.textSecondary)
    }
}

struct BookEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        BookEmptyView()
    }
}
