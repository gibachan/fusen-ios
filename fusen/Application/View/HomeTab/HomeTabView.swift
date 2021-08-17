//
//  HomeTabView.swift
//  HomeTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import SwiftUI

struct HomeTabView: View {
    @StateObject var viewModel = HomeTabViewModel()
    @State var isAddPresented = false
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    Section {
                        ForEach(viewModel.latestBooks) { book in
                            NavigationLink(destination: LazyView(BookView(book: book))) {
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
                
                ControlToolbar(
                    trailingImage: .memo,
                    trailingAction: {
                        isAddPresented = true
                    }
                )
            }
            .navigationBarTitle("ホーム")
        }
        .task {
            await viewModel.onAppear()
        }
        .sheet(isPresented: $isAddPresented) {
            print("dismissed")
        } content: {
            AddMemoView()
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
