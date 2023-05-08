//
//  AddBookView.swift
//  AddBookView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/23.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddBookViewModel()
    @State private var thumbnailImage: ImageData?
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var isThumbnailPickerPresented = false
    @State private var isCameraPickerPresented = false
    @State private var isPhotoLibraryPresented = false
    @FocusState private var focus: Bool
    private let collection: Collection?
    
    init(in collection: Collection? = nil) {
        self.collection = collection
    }
    
    var body: some View {
        Form {
            Section {
                Button {
                    isThumbnailPickerPresented = true
                } label: {
                    HStack(alignment: .bottom, spacing: 16) {
                        if let image = thumbnailImage,
                           let uiImage = image.uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 80)
                        } else {
                            BookImageView(url: nil)
                                .frame(width: 64, height: 80)
                        }
                        Text("画像をタップして変更")
                            .font(.small)
                            .foregroundColor(.textSecondary)
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
                        viewModel.onTextChange(title: newValue, author: author)
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
                        viewModel.onTextChange(title: title, author: newValue)
                    })
            } header: {
                SectionHeaderText("著者")
            }
            
            Spacer()
                .frame(height: 190)
                .listRowBackground(Color.backgroundSystemGroup)
        }
        .font(.medium)
        .navigationBarTitle("マニュアル入力", displayMode: .inline)
        .navigationBarItems(
            leading: CancelButton {
                dismiss()
            },
            trailing: SaveButton {
                Task {
                    await viewModel.onSave(title: title, author: author, thumbnailImage: thumbnailImage, collection: collection)
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
        .fullScreenCover(isPresented: $isCameraPickerPresented) {
            ImagePickerView(imageType: .book, pickerType: .camera) { result in
                switch result {
                case .success(let image):
                    thumbnailImage = image
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
                case .failure(let error):
                    log.e(error.localizedDescription)
                }
            }
        }
        .onAppear {
            if title.isEmpty {
                focus = true
            }
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loading:
                break
            case .succeeded:
                dismiss()
            case .failed:
                ErrorHUD.show(message: .addBook)
            }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
