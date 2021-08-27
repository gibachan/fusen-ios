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
    
    @State var thumbnailImage: ImageData?
    @State var title: String = ""
    @State var author: String = ""
    @State var isThumbnailPickerPresented = false
    @State var isCameraPickerPresented = false
    @State var isPhotoLibraryPresented = false
    
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
                                .scaledToFit()
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
                    await viewModel.onSave(title: title, author: author, thumbnailImage: thumbnailImage)
                }
            }
                .disabled(!viewModel.isSaveEnabled)
        )
        .actionSheet(isPresented: $isThumbnailPickerPresented) {
            ActionSheet(
                title: Text("書籍画像を変更"),
                buttons: [
                    .default(Text("カメラで撮影")) {
                        isCameraPickerPresented = true
                    },
                    .default(Text("フォトライブラリから選択")) {
                        isPhotoLibraryPresented = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $isCameraPickerPresented) {
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
