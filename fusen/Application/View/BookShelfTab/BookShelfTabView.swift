//
//  BookShelfTabView.swift
//  BookShelfTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

struct BookShelfTabView: View {
    @StateObject var viewModel = BookShelfTabViewModel()
    @State var isAddPresented = false
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    ForEach(viewModel.pager.data) { book in
                        NavigationLink(destination: LazyView(BookDetailView(book: book))) {
                            BookShelfItem(book: book)
                                .task {
                                    await viewModel.onItemApper(of: book)
                                }
                        }
                    }
                    if viewModel.pager.data.isEmpty {
                        // FIXME: show empty view
                        EmptyView()
                    }
                }
                .refreshable {
                    await viewModel.onRefresh()
                }
                HStack(alignment: .center) {
                    Spacer()
                    Text(viewModel.textCountText)
                        .font(.small)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    AddButton {
                        isAddPresented = true
                    }
                    .frame(width: 24, height: 24)
                    Spacer().frame(width: 16)
                }
                .frame(height: 48)
                .background(Color.backgroundGray)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("本棚")
            .sheet(isPresented: $isAddPresented) {
                print("dismissed")
            } content: {
                AddBookView()
            }
            
        }
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loadingNext, .refreshing:
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

struct BookShelfTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfTabView()
    }
}
