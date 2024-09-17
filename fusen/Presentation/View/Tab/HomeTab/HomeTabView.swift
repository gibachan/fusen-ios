//
//  HomeTabView.swift
//  HomeTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Domain
import SwiftUI

struct HomeTabView: View {
    private let readingBookFooterHeight: CGFloat = 56
    @StateObject private var viewModel = HomeTabViewModel()
    @State private var isAddPresented = false
    @State private var isNavigated = false
    @State private var navigation: HomeNavigation = .none

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
                    .frame(height: readingBookFooterHeight)
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                await viewModel.onRefresh()
            }

            if let readigBook = viewModel.readingBook {
                readingBookFooter(book: readigBook)
            }
        }
        .loading(viewModel.state == .loading)
        .navigation(isActive: $isNavigated, destination: {
            switch navigation {
            case .none:
                EmptyView()
            case let .book(book: book):
                BookView(bookId: book.id)
            case .allBooks:
                BookListView()
            case let .memo(memo: memo):
                EditMemoView(memo: memo)
            case .allMemos:
                MemoListView()
            }
        })
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
        .onReceive(NotificationCenter.default.tutorialFinishedPublisher()) { _ in
            Task {
                await viewModel.onRefresh()
            }
        }
        .onReceive(NotificationCenter.default.newMemoAddedViaDeepLinkPublisher()) { _ in
            Task {
                await viewModel.onRefresh()
            }
        }
        .onReceive(NotificationCenter.default.homePopToRootPublisher()) { _ in
            isNavigated = false
        }
    }
}

extension HomeTabView {
    private func navigate(to navigation: HomeNavigation) {
        self.navigation = navigation
        self.isNavigated = true
    }

    private func latestBooksSectin(books: [Book]) -> some View {
        Section {
            ForEach(books, id: \.id.value) { book in
                Button {
                    navigate(to: .book(book: book))
                } label: {
                    LatestBookItem(book: book)
                        .padding(.vertical, 4)
                }
            }
        } header: {
            HStack {
                SectionHeaderText("最近追加した書籍")
                Spacer()
                Button {
                    navigate(to: .allBooks)
                } label: {
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
                Button {
                    navigate(to: .memo(memo: memo))
                } label: {
                    LatestMemoItem(memo: memo)
                }
            }
        } header: {
            HStack {
                SectionHeaderText("最近追加したメモ")
                Spacer()
                Button {
                    navigate(to: .allMemos)
                } label: {
                    ShowAllText()
                }
            }
        }
    }

    private func readingBookFooter(book: Book) -> some View {
        HStack(alignment: .center) {
            Button {
                navigate(to: .book(book: book))
            } label: {
                HStack {
                    BookImageView(url: book.imageURL)
                        .frame(width: 30, height: 40)
                    VStack(alignment: .leading) {
                        Text("読書中")
                            .font(.small)
                            .foregroundColor(.textSecondary)
                        Text(book.title)
                            .font(.small)
                            .lineLimit(1)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            Spacer()
            Image.memo
                .resizable()
                .foregroundColor(.active)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    isAddPresented = true
                }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(height: readingBookFooterHeight)
        .backgroundColor(.white.opacity(0.94))
        .shadow(color: .backgroundGray, radius: 3)
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
