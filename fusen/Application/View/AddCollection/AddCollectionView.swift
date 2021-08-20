//
//  AddCollectionView.swift
//  AddCollectionView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/20.
//

import SwiftUI

struct AddCollectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddCollectionViewModel()
    @State private var name = ""
    @State private var color = Color.blue
    
    var body: some View {
        Form {
            Section {
                HStack(spacing: 4) {
                    Text("名前 : ")
                    TextField("名前を入力する", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: name) { newValue in
                            viewModel.onNameChange(newValue)
                        }
                }
                ColorPicker("カラー : ", selection: $color)
            } header: {
                SectionHeaderText("新しいコレクション")
            }
            .foregroundColor(.textSecondary)
            .listRowBackground(Color.backgroundLightGray)
        }
        .font(.medium)
        .navigationBarTitle("コレクションを追加", displayMode: .inline)
        .navigationBarItems(leading: CancelButton { dismiss() })
        .navigationBarItems(
            trailing: SaveButton {
                Task {
                    guard let rgb = color.rgb() else { return }
                    await viewModel.onSave(name: name, rgb: rgb)
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

struct AddCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddCollectionView()
    }
}
