//
//  AddMemoView.swift
//  AddMemoView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI
import VisionKit

struct AddMemoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddMemoViewModel
    @State private var text = ""
    @State private var quote = ""
    @State private var page = 0
    @State private var editMemoImage: AddMemoViewModel.ImageResult?
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
                                    takeImages()
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
                MemoImageView(image: result.image) {
                    viewModel.onMemoImageDelete(image: result)
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
                //                isErrorActive = true
            }
        }
    }
    
    private func takeImages() {
        guard VNDocumentCameraViewController.isSupported else {
            log.e("VNDocumentCameraViewController is not supported for simulator")
            return
        }
        guard let rootVC = UIApplication.shared.currentRootViewController else {
            log.e("RootViewController is missing")
            return
        }
        let vc = VNDocumentCameraViewController()
        vc.delegate = viewModel
        rootVC.present(vc, animated: true, completion: nil)
    }
}

struct AddMemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddMemoView(book: Book.sample)
        }
    }
}
