//
//  SearchBookView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/17.
//

import Domain
import SwiftUI

struct SearchBookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SearchBookViewModel
    @State private var searchText: String = ""
    @State private var isConfirmAlertPresented = false

    init(in collection: Domain.Collection? = nil) {
        self._viewModel = StateObject(wrappedValue: SearchBookViewModel(collection: collection))
    }

    var body: some View {
        ZStack {
            List {
                if case let .loaded(publications) = viewModel.state {
                    ForEach(publications, id: \.title) { publication in
                        SearchBookItemView(publication: publication)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.onSelect(publication: publication)
                                isConfirmAlertPresented = true
                            }
                    }
                }
            }
            if case .initial = viewModel.state {
                HStack {
                    Spacer()
                    Text("書籍をタイトルで検索してください")
                        .font(.medium)
                        .foregroundColor(.textSecondary)
                    Spacer()
                }
            }
        }
        .navigationBarTitle("書籍をタイトルで検索", displayMode: .inline)
        .loading(viewModel.state == .loading)
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("タイトルを入力"))
        .onSubmit(of: .search) {
            Task {
                await viewModel.onSearch(title: searchText)
            }
        }
        .alert(isPresented: $isConfirmAlertPresented) {
            Alert(
                title: Text("書籍を追加"),
                message: Text("書籍「\(viewModel.selectedPublication?.title ?? "")」を追加しますか？"),
                primaryButton: .default(Text("追加"), action: {
                    Task {
                        await viewModel.onAdd()
                    }
                }),
                secondaryButton: .cancel(Text("キャンセル"))
            )
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loading, .loaded:
                break
            case .added:
                dismiss()
            case .loadFailed:
                ErrorSnackbar.show(message: .network)
            case .addFailed:
                ErrorSnackbar.show(message: .addBook)
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
