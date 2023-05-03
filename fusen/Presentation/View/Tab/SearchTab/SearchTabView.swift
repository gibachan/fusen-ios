//
//  SearchTabView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/22.
//

import ComposableArchitecture
import SwiftUI

struct SearchTabView: View {
    var body: some View {
        SearchMemoView(
            store: Store(
                initialState: SearchMemo.State(),
                reducer: SearchMemo()
            )
        )
        .navigationBarTitle("検索")
    }
}

private struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchTabView()
        }
    }
}
