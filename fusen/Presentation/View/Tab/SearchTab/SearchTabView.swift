//
//  SearchTabView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/22.
//

import SwiftUI

struct SearchTabView: View {
    private let items: [String] = [
        "AAAA", "BBBB", "CCCC"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("検索")
    }
}
