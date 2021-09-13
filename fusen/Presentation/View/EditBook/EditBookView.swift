//
//  EditBookView.swift
//  EditBookView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditViewModel
    @State var title: String
    @State var author: String
    @State var description: String
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: EditViewModel(book: book))
        self._title = State(wrappedValue: book.title)
        self._author = State(wrappedValue: book.author)
        self._description = State(wrappedValue: book.description)
    }
    
    var body: some View {
        Form {
            Section {
                BookImageView(url: viewModel.imageURL)
                    .frame(width: 72, height: 80)
            } header: {
                SectionHeaderText("書籍画像")
            }
            .listRowBackground(Color.backgroundSystemGroup)
            
            Section {
                PlaceholderTextEditor(placeholder: "タイトルを入力", text: $title)
                    .font(.medium)
                    .foregroundColor(.textPrimary)
                    .frame(minHeight: 80)
                    .onChange(of: title, perform: { newValue in
                        viewModel.onTextChange(title: newValue, author: author, description: description)
                    })
            } header: {
                SectionHeaderText("タイトル（必須）")
            }

            Section {
                PlaceholderTextEditor(placeholder: "著者を入力", text: $author)
                    .font(.medium)
                    .foregroundColor(.textPrimary)
                    .frame(minHeight: 80)
                    .onChange(of: author, perform: { newValue in
                        viewModel.onTextChange(title: title, author: newValue, description: description)
                    })
            } header: {
                SectionHeaderText("著者")
            }

            Section {
                PlaceholderTextEditor(placeholder: "概要を入力", text: $description)
                    .font(.medium)
                    .foregroundColor(.textPrimary)
                    .frame(minHeight: 120)
                    .onChange(of: description, perform: { newValue in
                        viewModel.onTextChange(title: title, author: author, description: newValue)
                    })
            } header: {
                SectionHeaderText("概要")
            }
            
            Spacer()
                .frame(height: 160)
                .listRowBackground(Color.backgroundSystemGroup)
        }
        .font(.medium)
//        .sheet(isPresented: $isScanBarcodePresented, onDismiss: {
//            print("dimiss")
//        }, content: {
//            ScanBarcodeView()
//        })
//        .sheet(isPresented: $isManualInputPresented, onDismiss: {
//            print("dimiss")
//        }, content: {
//            Text("Not yet implemented")
//        })
        .navigationBarTitle("書籍を編集", displayMode: .inline)
        .navigationBarItems(
            trailing: SaveButton {
                Task {
                    await viewModel.onSave(title: title, author: author, description: description)
                }
            }
                .disabled(!viewModel.isSaveEnabled)
        )
        .task {
            viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial:
                break
            case .loading:
                LoadingHUD.show()
            case .succeeded:
                LoadingHUD.dismiss()
                dismiss()
            case .failed:
                LoadingHUD.dismiss()
            }
        }
    }
}

struct EditBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditBookView(book: Book.sample)
        }
    }
}
