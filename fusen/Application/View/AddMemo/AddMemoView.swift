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
    
    init(book: Book) {
        self._viewModel = StateObject(wrappedValue: AddMemoViewModel(book: book))
    }
    
    var body: some View {
        NavigationView {
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
            }
            .font(.medium)
            .navigationBarTitle("メモを追加", displayMode: .inline)
            .navigationBarItems(leading: CancelButton { dismiss() })
            .navigationBarItems(
                trailing: SaveButton {
                    Task {
                        await viewModel.onSave()
                    }
                }
                    .disabled(!viewModel.isSaveEnabled)
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
