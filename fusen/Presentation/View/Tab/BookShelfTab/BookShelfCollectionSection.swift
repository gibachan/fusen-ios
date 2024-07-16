//
//  BookShelfCollectionSection.swift
//  BookShelfCollectionSection
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Domain
import SwiftUI

struct BookShelfCollectionSection: View {
    @StateObject private var viewModel: BookShelfCollectionSectionModel
    private let collection: Domain.Collection
    @Binding var isNavigated: Bool
    @Binding var navigation: BookShelfNavigation

    init(collection: Domain.Collection, isNavigated: Binding<Bool>, navigation: Binding<BookShelfNavigation>) {
        self._viewModel = StateObject(wrappedValue: BookShelfCollectionSectionModel(collection: collection))
        self.collection = collection
        self._isNavigated = isNavigated
        self._navigation = navigation
    }
    
    var body: some View {
        Section {
            if viewModel.bookColumns.isEmpty {
                BookShelfEmptyItem()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(viewModel.bookColumns) { column in
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(column.books, id: \.id) { book in
                                    Button {
                                        navigate(to: .book(book: book))
                                    } label: {
                                        BookShelfItem(book: book)
                                    }
                                    if book.id != column.books.last?.id {
                                        Divider()
                                    }
                                }
                            }
                            .frame(width: 200)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        } header: {
            HStack {
                Image.collection
                    .resizable()
                    .frame(width: 20, height: 18)
                    .foregroundColor(Color(rgb: viewModel.collection.color))
                SectionHeaderText(viewModel.collection.name)
                Spacer()
                Button {
                    navigate(to: .collection(collection: collection))
                } label: {
                    ShowAllText()
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

extension BookShelfCollectionSection {
    private func navigate(to navigation: BookShelfNavigation) {
        self.navigation = navigation
        self.isNavigated = true
    }
}

struct BookShelfCollectionSection_Previews: PreviewProvider {
    static var previews: some View {
        BookShelfCollectionSection(collection: Collection.sample, isNavigated: Binding<Bool>.constant(false), navigation: Binding<BookShelfNavigation>.constant(.none))
    }
}
