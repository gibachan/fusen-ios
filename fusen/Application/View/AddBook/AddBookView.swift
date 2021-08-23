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

    @State var thumbnail: UIImage?
    @State var title: String = ""
    @State var author: String = ""
    
    var body: some View {
        Form {
            Section {
                BookImageView(url: nil)
                    .frame(width: 64, height: 80)
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
                .frame(height: 160)
                .listRowBackground(Color.backgroundSystemGroup)
        }
        .font(.medium)
//        .sheet(isPresented: $isScanBarcodePresented, onDismiss: {
//            print("dimiss")
//        }, content: {
//            ScanBarcodeView()
//        })
//        .sheet(isPresented: $isManualInputPresented, onDismiss: {
//            print("dimiss")
//        }, content: {
//            Text("Not yet implemented")
//        })
        .navigationBarTitle("マニュアル入力", displayMode: .inline)
        .navigationBarItems(
            leading: CancelButton {
                dismiss()
            },
            trailing: SaveButton {
                Task {
                    await viewModel.onSave(title: title, author: author)
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

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
