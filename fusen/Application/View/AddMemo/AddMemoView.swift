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
                
                VStack {
                    Button {
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
                    } label: {
                        HStack(spacing: 8) {
                            Image.camera
                                .resizable()
                                .frame(width: 28, height: 24)
                            Text("画像を撮影")
                        }
                        .foregroundColor(.blue)
                    }
                    
                    HStack {
                        ForEach(viewModel.imageResults) { result in
                            Image(uiImage: result.image)
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                    }
                    
                    if viewModel.imageCountLimitOver {
                        Text("撮影可能な画像枚数を超えています")
                    }
                }
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
}

struct AddMemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddMemoView(book: Book.sample)
        }
    }
}
