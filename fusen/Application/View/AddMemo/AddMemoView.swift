//
//  AddMemoView.swift
//  AddMemoView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct AddMemoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddMemoViewModel
    @State private var text = ""
    @State private var quote = ""
    @State private var page = 0
    @State private var editMemoImage: DocumentCameraView.ImageResult?
    @State private var isDocumentCameraPresented = false
    private let memoImageWidth: CGFloat = 72
    private let memoImageHeight: CGFloat = 96
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: AddMemoViewModel(book: book))
    }
    
    var body: some View {
        Form {
            Section {
                PlaceholderTextEditor(placeholder: "メモを入力する", text: $text)
                    .frame(minHeight: 120)
                    .onChange(of: text) { newValue in
                        viewModel.onTextChange(newValue)
                    }
            } header: {
                SectionHeaderText("メモ")
            }
            Section {
                PlaceholderTextEditor(placeholder: "引用する文を入力する", text: $quote)
                    .frame(minHeight: 100)
                
                Picker(
                    selection: $page,
                    label: Text("ページ")
                ) {
                    ForEach(0..<999) { page in
                        Text("\(page)")
                    }
                }
                .frame(minHeight: 40)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("画像を撮影 :")
                    HStack {
                        if viewModel.imageResults.isEmpty {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.placeholder, lineWidth: 1)
                                .frame(width: memoImageWidth, height: memoImageHeight)
                                .overlay(Image.camera
                                            .resizable()
                                            .frame(width: 32, height: 24)
                                            .foregroundColor(.placeholder))
                                .onTapGesture {
                                    isDocumentCameraPresented = true
                                }
                        } else {
                            ForEach(viewModel.imageResults) { result in
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.placeholder, lineWidth: 1)
                                    .frame(width: memoImageWidth, height: memoImageHeight)
                                    .overlay(
                                        Image(uiImage: result.image)
                                            .resizable()
                                    )
                                    .onTapGesture {
                                        editMemoImage = result
                                    }
                            }
                        }
                        Spacer()
                    }
                    
                    Text("※ 画像は1枚のみ保存できます")
                        .font(.small)
                        .foregroundColor(.textSecondary)
                }
                .padding(.vertical, 8)
            } header: {
                SectionHeaderText("引用(オプション）")
            }
            .foregroundColor(.textSecondary)
            .listRowBackground(Color.backgroundLightGray)
            
            Spacer()
                .frame(height: 160)
                .listRowBackground(Color(UIColor.systemGroupedBackground))
        }
        .font(.medium)
        .navigationBarTitle("メモを追加", displayMode: .inline)
        .navigationBarItems(leading: CancelButton { dismiss() })
        .navigationBarItems(
            trailing: SaveButton {
                Task {
                    await viewModel.onSave(text: text, quote: quote, page: page, imageURLs: [])
                }
            }
                .disabled(!viewModel.isSaveEnabled)
        )
        .sheet(item: $editMemoImage, onDismiss: {}, content: { result in
            NavigationView {
                AddMemoImageView(image: result.image) {
                    viewModel.onMemoImageDelete(image: result)
                }
            }
        })
        .fullScreenCover(isPresented: $isDocumentCameraPresented, onDismiss: {
            log.d("dismiss")
        }, content: {
            DocumentCameraView { result in
                switch result {
                case .success(let images):
                    viewModel.onMemoImageAdd(images: images)
                case .failure(let error):
                    log.e(error.localizedDescription)
                    ErrorHUD.show(message: .unexpected)
                }
            }
        })
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
