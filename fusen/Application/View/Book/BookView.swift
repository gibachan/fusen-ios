//
//  BookView.swift
//  BookView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/16.
//

import SwiftUI

struct BookView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: BookViewModel
    //    @State private var isFavorite = false
    
    init(bookId: ID<Book>) {
        self._viewModel = StateObject(wrappedValue: BookViewModel(bookId: bookId))
        // FIXME: Fetch book by its id
        //        self.isFavorite = book.isFavorite
    }
    
    var body: some View {
        Group {
            if let book = viewModel.book {
                BookContentView(
                    book: book,
                    isReadingBook: viewModel.isReadingBook,
                    memos: viewModel.memoPager.data,
                    memoItemAppearAction: { memo in
                        Task {
                            await viewModel.onItemApper(of: memo)
                        }
                    },
                    readingToggleAction: {
                        Task {
                            await viewModel.onReadingToggle()
                        }
                    },
                    deleteActin: {
                        Task {
                            await viewModel.onDelete()
                        }
                    }
                )
            } else {
                BookEmptyView()
            }
        }
        .navigationBarTitle("書籍", displayMode: .inline)
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial:
                break
            case .loading:
                LoadingHUD.show()
            case .loadingNext:
                LoadingHUD.dismiss()
            case .succeeded:
                LoadingHUD.dismiss()
            case .deleted:
                LoadingHUD.dismiss()
                dismiss()
            case .failed:
                LoadingHUD.dismiss()
                //                isErrorActive = true
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookView(bookId: Book.sample.id)
        }
    }
}
