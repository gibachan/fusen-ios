//
//  SearchBookView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import SwiftUI

struct SearchBookView: View {
    @StateObject private var viewModel: SearchBookViewModel
    @State private var searchText: String = ""
    
    init() {
        self._viewModel = StateObject(wrappedValue: SearchBookViewModel())
    }

    var body: some View {
        List {
            if case let .loaded(publications) = viewModel.state {
                ForEach(publications, id: \.title) { publication in
                    Text(publication.title)
                }
            } else {
                Text("Empty")
            }
        }
        .navigationBarTitle("書籍をタイトルで検索", displayMode: .inline)
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("タイトルを入力"))
        .onSubmit(of: .search) {
            Task {
                await viewModel.onSearch(title: searchText)
            }
        }
    }
}

struct SearchBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchBookView()
        }
    }
}
