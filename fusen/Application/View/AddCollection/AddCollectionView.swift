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
                if viewModel.isCollectionCountOver {
                    Text("コレクションの上限数を超えたため、新たに作成できません。")
                        .padding(.bottom, 16)
                        .font(.medium)
                        .foregroundColor(.error)
                        .listRowSeparator(.hidden)
                }
                HStack(spacing: 4) {
                    Text("名前 : ")
                    TextField("名前を入力する", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .disabled(viewModel.isCollectionCountOver)
                        .onChange(of: name) { newValue in
                            viewModel.onNameChange(newValue)
                        }
                }
                ColorPicker("カラー : ", selection: $color)
                    .disabled(viewModel.isCollectionCountOver)
            } header: {
                SectionHeaderText("新しいコレクション")
            }
            .foregroundColor(.textSecondary)
        }
        .font(.medium)
        .navigationBarTitle("コレクションを追加", displayMode: .inline)
        .navigationBarItems(leading: CancelButton { dismiss() })
        .navigationBarItems(
            trailing: SaveButton {
                Task {
                    guard let rgb = color.rgb() else { return }
                    await viewModel.onSave(name: name, color: rgb)
                }
            }
                .disabled(!viewModel.isSaveEnabled)
        )
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial:
                break
            case .loading:
                LoadingHUD.show()
            case .collectionsLoaded:
                LoadingHUD.dismiss()
            case .collectionAdded:
                LoadingHUD.dismiss()
                dismiss()
            case .failed:
                LoadingHUD.dismiss()
                ErrorHUD.show(message: .addCollection)
            case .collectionCountOver:
                LoadingHUD.dismiss()
                ErrorHUD.show(message: .collectionCountOver)
            }
        }
    }
}

struct AddCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddCollectionView()
    }
}
