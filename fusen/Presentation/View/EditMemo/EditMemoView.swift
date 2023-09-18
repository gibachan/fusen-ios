//
//  EditMemoView.swift
//  EditMemoView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/18.
//

import Domain
import SwiftUI

struct EditMemoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditMemoViewModel
    @State private var text: String
    @State private var quote: String
    @State private var page: Int
    @State private var isMemoImagePresented = false
    @State private var isDeleteAlertPresented = false
    @FocusState private var focus: Bool
    
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
                        .focused($focus)
                } header: {
                    HStack {
                        SectionHeaderText("メモ")
                        Spacer()
                        share(text: text)
                    }
                }
                Section {
                    PlaceholderTextEditor(placeholder: "引用する文を入力する", text: $quote)
                        .frame(minHeight: 100)
                        .onChange(of: quote) { newValue in
                            viewModel.onTextChange(text: text, quote: newValue)
                        }
                    
                    NavigationLink {
                        PageListView(page: $page, initialPage: page)
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
                    HStack {
                        SectionHeaderText("書籍から引用")
                        Spacer()
                        share(text: quote)
                    }
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
                        .onTapGesture {
                            isDeleteAlertPresented = true
                        }
                },
                trailingView: { EmptyView() }
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
        .loading(viewModel.state == .loading)
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
        .task {
            if text.isEmpty {
                focus = true
            }
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loading, .failed:
                break
            case .succeeded:
                dismiss()
            case .deleted:
                dismiss()
            }
        }
    }
}

extension EditMemoView {
    func share(text: String) -> some View {
        Group {
            if let book = viewModel.book, text.isNotEmpty {
                Image.share
                    .resizable()
                    .frame(width: 16, height: 20)
                    .foregroundColor(.textPrimary)
                    .onTapGesture {
                        share(text: "\(text) （『\(book.title)』より）")
                    }
            } else {
                Image.share
                    .resizable()
                    .frame(width: 16, height: 20)
                    .foregroundColor(.inactive)
            }
        }
    }
}

struct EditMemoView_Previews: PreviewProvider {
    static var previews: some View {
        EditMemoView(memo: Memo.sample)
    }
}
