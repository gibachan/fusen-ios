//
//  EditMemoView.swift
//  EditMemoView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import SwiftUI

struct EditMemoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditMemoViewModel
    @State private var text: String
    @State private var quote: String
    @State private var page: Int
    @State private var editMemoImage: EditMemoViewModel.EditMemoImage?
    @State private var isDeleteAlertPresented = false
    @State private var isDocumentCameraPresented = false
    private let memoImageWidth: CGFloat = 72
    private let memoImageHeight: CGFloat = 96
    
    init(memo: Memo) {
        self._viewModel = StateObject(wrappedValue: EditMemoViewModel(memo: memo))
        self._text = State(wrappedValue: memo.text)
        self._quote = State(wrappedValue: memo.quote)
        self._page = State(wrappedValue: memo.page ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                        label: Text("ページ :")
                    ) {
                        ForEach(0..<999) { page in
                            Text("\(page)")
                        }
                    }
                    .frame(minHeight: 40)
                    
                    if !viewModel.memo.imageURLs.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("画像 :")
                            HStack {
                                ForEach(viewModel.memoImages, id: \.self) { image in
                                    switch image.type {
                                    case .url(let url):
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                        } placeholder: {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.placeholder)
                                        }
                                        .frame(width: memoImageWidth, height: memoImageHeight)
                                        .onTapGesture {
                                            editMemoImage = image
                                        }
                                    case .memory:
                                        EmptyView()
                                    }
                                }
                                Spacer()
                            }
                        }
                        .padding(.vertical, 8)
                    }
                } header: {
                    SectionHeaderText("引用(オプション）")
                }
                .foregroundColor(.textSecondary)
                .listRowBackground(Color.backgroundLightGray)
            }
            .font(.medium)
            
            ControlToolbar(
                leadingView: {
                    Image.delete
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                },
                leadingAction: {
                    isDeleteAlertPresented = true
                },
                trailingView: { EmptyView() },
                trailingAction: {}
            )
        }
        .navigationBarTitle("メモを編集", displayMode: .inline)
        .navigationBarItems(
            trailing: SaveButton {
                Task {
                    await viewModel.onSave(text: text, quote: quote, page: page, imageURLs: [])
                }
            }
                .disabled(!viewModel.isSaveEnabled)
        )
        .sheet(item: $editMemoImage, onDismiss: {}, content: { image in
            NavigationView {
                switch image.type {
                case .url(let url):
                    EditMemoImageView(url: url) {
                        //                    viewModel.onMemoImageDelete(image: result)
                    }
                case .memory:
                    EmptyView()
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
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("メモを削除"),
                message: Text("メモを削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("削除"), action: {
                    Task {
                        await viewModel.onDelete()
                    }
                })
            )
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
            case .deleted:
                LoadingHUD.dismiss()
                dismiss()
            case .failed:
                LoadingHUD.dismiss()
            }
        }
    }
}

struct EditMemoView_Previews: PreviewProvider {
    static var previews: some View {
        EditMemoView(memo: Memo.sample)
    }
}
