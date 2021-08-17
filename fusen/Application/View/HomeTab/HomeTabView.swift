//
//  HomeTabView.swift
//  HomeTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import SwiftUI

struct HomeTabView: View {
    @StateObject var viewModel = HomeTabViewModel()
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.latestBooks) { book in
                        NavigationLink(destination: LazyView(BookDetailView(book: book))) {
                            LatestBookItem(book: book)
                        }
                    }
                } header: {
                    HStack {
                        SectionHeaderText("最近追加した書籍")
                        Spacer()
                        NavigationLink(destination: Text("書籍詳細")) {
                            ShowAllText()
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("ホーム")
        }
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial:
                break
            case .loading:
                LoadingHUD.show()
            case .succeeded:
                LoadingHUD.dismiss()
            case .failed:
                LoadingHUD.dismiss()
                //                isErrorActive = true
            }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
