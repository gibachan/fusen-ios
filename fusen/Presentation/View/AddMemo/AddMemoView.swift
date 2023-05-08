//
//  AddMemoView.swift
//  AddMemoView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import StoreKit
import SwiftUI

struct AddMemoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddMemoViewModel
    @State private var text = ""
    @State private var quote = ""
    @State private var page = 0
    @State private var image: ImageData?
    @State private var isEditMemoImage = false
    @State private var isImagePickerSelectionPresented = false
    @State private var isCameraPickerPresented = false
    @State private var isPhotoLibraryPresented = false
    @State private var isQuoteCameraPresented = false
    @FocusState private var focus: Bool
    private let memoImageWidth: CGFloat = 72
    private let memoImageHeight: CGFloat = 96
    private let isImageAvailable = false
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: AddMemoViewModel(book: book))
    }
    
    var body: some View {
        Form {
            Section {
                PlaceholderTextEditor(placeholder: "メモを入力する", text: $text)
                    .frame(minHeight: 120)
                    .onChange(of: text) { newValue in
                        viewModel.onTextChange(text: newValue, quote: quote)
                    }
                    .focused($focus)
            } header: {
                SectionHeaderText("メモ")
            }
            Section {
                PlaceholderTextEditor(placeholder: "引用する文を入力する", text: $quote)
                    .frame(minHeight: 100)
                    .onChange(of: quote) { newValue in
                        viewModel.onTextChange(text: text, quote: newValue)
                    }
                
                NavigationLink {
                    PageListView(page: $page, initialPage: viewModel.initialPage)
                } label: {
                    HStack {
                        Text("ページ :")
                        Spacer()
                        if page != 0 {
                            Text("\(page)")
                        }
                    }
                }
                .frame(minHeight: 40)
                
                if isImageAvailable {
                    HStack(alignment: .top) {
                        Text("画像を添付 :")
                        Spacer()
                        HStack {
                            if let image = image,
                               let uiImage = image.uiImage {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.placeholder, lineWidth: 1)
                                    .frame(width: memoImageWidth, height: memoImageHeight)
                                    .overlay(
                                        Image(uiImage: uiImage)
                                            .resizable()
                                    )
                                    .onTapGesture {
                                        isEditMemoImage = true
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.active, lineWidth: 1)
                                    .frame(width: memoImageWidth, height: memoImageHeight)
                                    .overlay(Image.image
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.active))
                                    .onTapGesture {
                                        isImagePickerSelectionPresented = true
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            } header: {
                HStack(alignment: .center) {
                    SectionHeaderText("書籍から引用")
                    Spacer()
                    Button {
                        isQuoteCameraPresented = true
                    } label: {
                        Image.camera
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 20)
                            .foregroundColor(.active)
                    }
                }
            }
            .foregroundColor(.textSecondary)
            .listRowBackground(Color.backgroundLightGray)
        }
        .font(.medium)
        .navigationBarTitle("メモを追加", displayMode: .inline)
        .navigationBarItems(leading: CancelButton { dismiss() })
        .navigationBarItems(
            trailing: SaveButton {
                Task {
                    await viewModel.onSave(text: text, quote: quote, page: page, image: image)
                }
            }
                .disabled(!viewModel.isSaveEnabled)
        )
        .loading(viewModel.isLoading)
        .confirmationDialog("画像を添付", isPresented: $isImagePickerSelectionPresented, titleVisibility: .visible) {
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
        .sheet(isPresented: $isEditMemoImage, onDismiss: {
        }, content: {
            NavigationView {
                if let image = image,
                   let uiImage = image.uiImage {
                    AddMemoImageView(image: uiImage) {
                        self.image = nil
                    }
                }
            }
        })
        .fullScreenCover(isPresented: $isQuoteCameraPresented, onDismiss: {
            log.d("dismiss")
        }, content: {
            MemoQuoteView { result in
                switch result {
                case .success(let imageData):
                    Task {
                        await viewModel.onQuoteImageTaken(imageData: imageData)
                    }
                case .failure(let error):
                    log.e(error.localizedDescription)
                    ErrorHUD.show(message: .unexpected)
                }
            }
        })
        .fullScreenCover(isPresented: $isCameraPickerPresented) {
            ImagePickerView(imageType: .book, pickerType: .camera) { result in
                switch result {
                case .success(let image):
                    self.image = image
                case .failure(let error):
                    log.e(error.localizedDescription)
                }
            }
        }
        .sheet(isPresented: $isPhotoLibraryPresented) {
            ImagePickerView(imageType: .book, pickerType: .photoLibrary) { result in
                switch result {
                case .success(let image):
                    self.image = image
                case .failure(let error):
                    log.e(error.localizedDescription)
                }
            }
        }
        .task {
            await viewModel.onAppear()
        }
        .onAppear {
            if text.isEmpty {
                focus = true
            }
        }
        .onReceive(viewModel.$recognizedQuote) { recognizedQuote in
            quote = recognizedQuote
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loading, .recognizedQuote:
                break
            case let .succeeded(showAppReview):
                if showAppReview {
                    if let windowScene = UIApplication.shared.currentKeyWindow?.windowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                }
                dismiss()
            case .failed:
                ErrorHUD.show(message: .addMemo)
            }
        }
    }
}

struct AddMemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddMemoView(book: Book.sample)
        }
    }
}
