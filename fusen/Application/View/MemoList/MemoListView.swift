//
//  MemoListView.swift
//  MemoListView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/19.
//

import SwiftUI

struct MemoListView: View {
    @StateObject private var viewModel = MemoListViewModel()
    @State private var isAddPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(viewModel.pager.data, id: \.id.value) { memo in
                    NavigationLink(destination: LazyView(EditMemoView(memo: memo))) {
                        MemoListItem(memo: memo)
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
            
//            TrailingControlToolbar(
//                trailingView: {
//                    Image.add
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                },
//                trailingAction: {
//                    isAddPresented = true
//                }
//            )
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("すべてのメモ", displayMode: .inline)
        .sheet(isPresented: $isAddPresented) {
            print("dismissed")
        } content: {
            AddBookMenuView()
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

struct MemoListView_Previews: PreviewProvider {
    static var previews: some View {
        MemoListView()
    }
}
