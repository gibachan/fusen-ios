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
    @State private var text = ""
    @State private var quote = ""
    @State private var page = 0
    @State private var isDeleteAlertPresented = false
    private let currentMemo: Memo

    init(book: Book, memo: Memo) {
        self.currentMemo = memo
        self._viewModel = StateObject(wrappedValue: EditMemoViewModel(book: book, memo: memo))
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
            } header: {
                SectionHeaderText("引用(オプション）")
            }
            .foregroundColor(.textSecondary)
            .listRowBackground(Color.backgroundLightGray)
            
            Section {
                Section {
                    HStack {
                        Spacer()
                        Button(role: .destructive) {
                            isDeleteAlertPresented = true
                        } label: {
                            Text("削除")
                                .font(.medium)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }
            }
        }
        .font(.medium)
        .navigationBarTitle("メモを編集", displayMode: .inline)
        .navigationBarItems(
            trailing: SaveButton {
                Task {
                    await viewModel.onSave(text: text, quote: quote, page: page, imageURLs: [])
                }
            }
                .disabled(!viewModel.isSaveEnabled)
        )
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
        .task {
            text = currentMemo.text
            quote = currentMemo.quote
            page = currentMemo.page ?? 0
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
                //                isErrorActive = true
            }
        }
    }
}

struct EditMemoView_Previews: PreviewProvider {
    static var previews: some View {
        EditMemoView(book: Book.sample, memo: Memo.sample)
    }
}