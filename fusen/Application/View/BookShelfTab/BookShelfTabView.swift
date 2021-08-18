//
//  BookShelfTabView.swift
//  BookShelfTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/10.
//

import SwiftUI

struct BookShelfTabView: View {
    @StateObject private var viewModel = BookShelfTabViewModel()
    @State private var isAddPresented = false
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    ForEach(viewModel.collections, id: \.id.value) { collection in
                        BookShelfSection(collection: collection)
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    await viewModel.onRefresh()
                }
                
                ControlToolbar(
                    text: viewModel.textCountText,
                    trailingImage: .add,
                    trailingAction: {
                        isAddPresented = true
                    }
                )
            }
            .listStyle(PlainListStyle())
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
        .onReceive(NotificationCenter.default.refreshBookShelfPublisher()) { _ in
            Task {
                await viewModel.onRefresh()
            }
        }
    }
}

struct BookShelfTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfTabView()
    }
}
