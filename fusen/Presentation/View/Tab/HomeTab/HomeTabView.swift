//
//  HomeTabView.swift
//  HomeTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import Domain
import SwiftUI

struct HomeTabView: View {
    @StateObject private var viewModel = HomeTabViewModel()
    @State private var isAddPresented = false
    @State private var isNavigated = false
    @State private var navigation: HomeNavigation = .none

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if case let .loaded(latestBooks, latestMemos) = viewModel.state {
                    if let readigBook = viewModel.readingBook {
                        readingBookSection(book: readigBook)
                    }
                    latestBooksSectin(books: latestBooks)
                    Divider()
                    latestMemosSection(memos: latestMemos)
                }

                if case .empty = viewModel.state {
                    HomeTabEmptyView()
                }
            }
            .padding(16)
        }
        .refreshable {
            await viewModel.onRefresh()
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

    private func readingBookSection(book: Book) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionHeaderText("読書中の書籍")
            HStack(alignment: .center) {
                Button {
                    navigate(to: .book(book: book))
                } label: {
                    HStack {
                        BookImageView(url: book.imageURL)
                            .frame(width: 30, height: 40)
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.small)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.textSecondary)
                            Spacer()
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
                    .padding(.trailing, 8)
            }
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.border, lineWidth: 0.5)
                    .shadow(color: .backgroundGray, radius: 1, x: 2, y: 2)
            )
        }
        .padding(.bottom, 20)
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
