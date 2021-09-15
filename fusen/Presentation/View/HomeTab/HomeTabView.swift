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
        ZStack(alignment: .bottomLeading) {
            List {
                if case let .loaded(latestBooks, latestMemos) = viewModel.state {
                    latestBooksSectin(books: latestBooks)
                    latestMemosSection(memos: latestMemos)
                }
                
                if case .empty = viewModel.state {
                    HomeTabEmptyView()
                        .listRowSeparator(.hidden)
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
        .task {
            await viewModel.onAppear()
        }
        .sheet(isPresented: $isAddPresented) {
            Task {
                await viewModel.onRefresh()
            }
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
            case .loaded, .empty:
                LoadingHUD.dismiss()
            case .failed:
                LoadingHUD.dismiss()
            }
        }
        .onReceive(NotificationCenter.default.tutorialFinishedPublisher()) { _ in
            Task {
                await viewModel.onRefresh()
            }
        }
        .onReceive(NotificationCenter.default.homePopToRootPublisher()) { _ in
            // This is a workaround for popToRootViewController
            Task {
                await viewModel.onAppear()
            }
        }
    }
}

extension HomeTabView {
    private func latestBooksSectin(books: [Book]) -> some View {
        Section {
            ForEach(books, id: \.id.value) { book in
                NavigationLink(destination: LazyView(BookView(bookId: book.id))) {
                    LatestBookItem(book: book)
                        .padding(.vertical, 4)
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
    }
    
    private func latestMemosSection(memos: [Memo]) -> some View {
        Section {
            if memos.isEmpty {
                BookEmptyMemoItem()
                    .listRowSeparator(.hidden)
            }
            ForEach(memos, id: \.id.value) { memo in
                NavigationLink(destination: LazyView(EditMemoView(memo: memo))) {
                    LatestMemoItem(memo: memo)
                        .padding(.vertical, 4)
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
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
