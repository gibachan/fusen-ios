//
//  HomeTabView.swift
//  HomeTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import SwiftUI

struct HomeTabView: View {
    @StateObject private var viewModel = HomeTabViewModel()
    @State private var isAddPresented = false
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                List {
                    Section {
                        ForEach(viewModel.latestBooks, id: \.id.value) { book in
                            NavigationLink(destination: LazyView(BookView(bookId: book.id))) {
                                LatestBookItem(book: book)
                            }
                        }
                    } header: {
                        HStack {
                            SectionHeaderText("最近追加した書籍")
                            Spacer()
                            NavigationLink(destination: LazyView(BookListView())) {
                                ShowAllText()
                            }
                        }
                    }
                    
                    Section {
                        ForEach(viewModel.latestMemos, id: \.id.value) { memo in
                            NavigationLink(destination: LazyView(EditMemoView(memo: memo))) {
                                LatestMemoItem(memo: memo)
                            }
                        }
                    } header: {
                        HStack {
                            SectionHeaderText("最近追加したメモ")
                            Spacer()
                            NavigationLink(destination: MemoListView()) {
                                ShowAllText()
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: HomeReadingBookItem.height)
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    await viewModel.onRefresh()
                }
                if let readigBook = viewModel.readingBook {
                    HomeReadingBookItem(book: readigBook) {
                        isAddPresented = true
                    }
                }
            }
            .navigationBarTitle("ホーム")
        }
        .task {
            await viewModel.onAppear()
        }
        .sheet(isPresented: $isAddPresented) {
            print("dismissed")
        } content: {
            NavigationView {
                if let readingBook = viewModel.readingBook {
                    AddMemoView(book: readingBook)
                }
            }
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
