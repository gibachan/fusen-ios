//
//  EditBookView.swift
//  EditBookView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import Domain
import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditViewModel
    @State var title: String
    @State var author: String
    @State var description: String
    @State private var thumbnailImage: ImageData?
    @State private var isThumbnailPickerPresented = false
    @State private var isCameraPickerPresented = false
    @State private var isPhotoLibraryPresented = false

    @FocusState private var focus: Bool
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: EditViewModel(book: book))
        self._title = State(wrappedValue: book.title)
        self._author = State(wrappedValue: book.author)
        self._description = State(wrappedValue: book.description)
    }
    
    var body: some View {
        Form {
            Section {
                Button {
                    isThumbnailPickerPresented = true
                } label: {
                    if let image = thumbnailImage,
                       let uiImage = image.uiImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 80)
                    } else {
                        BookImageView(url: viewModel.imageURL)
                            .frame(width: 64, height: 80)
                    }
                }
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
                    .focused($focus)
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
        .navigationBarTitle("書籍を編集", displayMode: .inline)
        .navigationBarItems(
            trailing: SaveButton {
                Task {
                    await viewModel.onSave(image: thumbnailImage, title: title, author: author, description: description)
                }
            }
                .disabled(!viewModel.isSaveEnabled)
        )
        .loading(viewModel.state == .loading)
        .confirmationDialog("書籍画像を変更", isPresented: $isThumbnailPickerPresented, titleVisibility: .visible) {
            Button {
                isCameraPickerPresented = true
            } label: {
                Text("カメラで撮影")
            }
            Button {
                isPhotoLibraryPresented = true
            } label: {
                Text("フォトライブラリから選択")
            }
            Button("キャンセル", role: .cancel, action: {})
        }
        .task {
            viewModel.onAppear()
        }
        .onAppear {
            if title.isEmpty {
                focus = true
            }
        }
        .fullScreenCover(isPresented: $isCameraPickerPresented) {
            ImagePickerView(imageType: .book, pickerType: .camera) { result in
                switch result {
                case .success(let image):
                    thumbnailImage = image
                    viewModel.onThumbnailImageChange()
                case .failure(let error):
                    log.e(error.localizedDescription)
                }
            }
        }
        .sheet(isPresented: $isPhotoLibraryPresented) {
            ImagePickerView(imageType: .book, pickerType: .photoLibrary) { result in
                switch result {
                case .success(let image):
                    thumbnailImage = image
                    viewModel.onThumbnailImageChange()
                case .failure(let error):
                    log.e(error.localizedDescription)
                }
            }
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loading, .failed:
                break
            case .succeeded:
                dismiss()
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
