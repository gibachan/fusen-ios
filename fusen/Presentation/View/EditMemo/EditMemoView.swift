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
    @State private var isMemoImagePresented = false
    @State private var isDeleteAlertPresented = false
    
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
                            viewModel.onTextChange(text: newValue, quote: quote)
                        }
                } header: {
                    SectionHeaderText("メモ")
                }
                Section {
                    PlaceholderTextEditor(placeholder: "引用する文を入力する", text: $quote)
                        .frame(minHeight: 100)
                        .onChange(of: quote) { newValue in
                            viewModel.onTextChange(text: text, quote: newValue)
                        }
                    
                    Picker(
                        selection: $page,
                        label: Text("ページ :")
                    ) {
                        ForEach(0..<999) { page in
                            Text("\(page)")
                        }
                    }
                    .frame(minHeight: 40)
                    
                    if let url = viewModel.memoImageURL {
                        HStack(alignment: .top) {
                            Text("添付画像 :")
                            Spacer()
                            MemoImageView(url: url)
                                .frame(width: 180, height: 180)
                                .onTapGesture {
                                    isMemoImagePresented = true
                                }
                        }
                    }
                } header: {
                    SectionHeaderText("書籍から引用")
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
                .backgroundColor(.backgroundSystemGroup)
        }
        .navigationBarTitle("メモを編集", displayMode: .inline)
        .navigationBarItems(
            trailing: SaveButton {
                Task {
                    await viewModel.onSave(text: text, quote: quote, page: page)
                }
            }
                .disabled(!viewModel.isSaveEnabled)
        )
        .sheet(isPresented: $isMemoImagePresented, onDismiss: {
        }, content: {
            NavigationView {
                EditMemoImageView(url: viewModel.memoImageURL)
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