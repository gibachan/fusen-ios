//
//  AddBookMenuView.swift
//  AddBookMenuView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/11.
//

import Domain
import SwiftUI

struct AddBookMenuView: View {
    private let noCollectionSelectedTag = ""

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddBookMenuViewModel
    @State private var isScanBarcodePresented = false
    @State private var isSearchPresented = false
    @State private var isManualInputPresented = false
    @State private var selectedCollection = ""

    init(in initialCollection: Domain.Collection? = nil) {
        self._viewModel = StateObject(wrappedValue: AddBookMenuViewModel(initialCollection: initialCollection))
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button {
                        isScanBarcodePresented = true
                    } label: {
                        AddBookMenuItem(type: AddBookMenuType.camera)
                    }
                    Button {
                        isSearchPresented = true
                    } label: {
                        AddBookMenuItem(type: AddBookMenuType.search)
                    }
                    Button {
                        isManualInputPresented = true
                    } label: {
                        AddBookMenuItem(type: AddBookMenuType.manual)
                    }
                }

                // FIXME: unexpected build error occures
                if viewModel.collections.isNotEmpty {
//                    Section {
//                        Picker(
//                            selection: $selectedCollection,
//                            label: Text("コレクション :")                            .foregroundColor(.textPrimary)
//                        ) {
//                            Text("指定なし")
//                                .tag(noCollectionSelectedTag)
//                                .foregroundColor(.textSecondary)
//                            ForEach(viewModel.collections, id: \.name) { collection in
//                                Text(collection.name)
//                                    .tag(collection.id.value)
//                                    .foregroundColor(.textSecondary)
//                            }
//                        }
//                        .font(.medium)
//                        .onChange(of: selectedCollection) { newValue in
//                            viewModel.onSelectCollection(id: ID<Domain.Collection>(value: newValue))
//                        }
//                    } header: {
//                        SectionHeaderText("追加するコレクション")
//                    }
                }
            }
            .fullScreenCover(isPresented: $isScanBarcodePresented, onDismiss: {
                print("dimiss")
            }, content: {
                NavigationView {
                    ScanBarcodeView(in: viewModel.selectedCollection)
                }
            })
            .sheet(isPresented: $isSearchPresented, onDismiss: {
                print("dimiss")
            }, content: {
                NavigationView {
                    SearchBookView(in: viewModel.selectedCollection)
                }
            })
            .sheet(isPresented: $isManualInputPresented, onDismiss: {
                print("dimiss")
            }, content: {
                NavigationView {
                    AddBookView(in: viewModel.selectedCollection)
                }
            })
            .navigationBarTitle("書籍を追加", displayMode: .inline)
            .navigationBarItems(leading: CancelButton { dismiss() })
            .task {
                await viewModel.onAppear()
            }
            .onReceive(viewModel.$selectedCollection) { selectedCollection in
                self.selectedCollection = selectedCollection?.id.value ?? noCollectionSelectedTag
            }
        }
    }
}

enum AddBookMenuType: Identifiable, CaseIterable {
    case camera
    case search
    case manual

    var id: String { title }

    var title: String {
        switch self {
        case .camera: return "バーコードを読み取る"
        case .search: return "タイトルで検索"
        case .manual: return "マニュアル入力する"
        }
    }

    var icon: Image {
        switch self {
        case .camera: return .camera
        case .search: return .search
        case .manual: return .manual
        }
    }
}

struct AddBookMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookMenuView()
    }
}
