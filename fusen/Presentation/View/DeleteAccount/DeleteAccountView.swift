//
//  DeleteAccountView.swift
//  DeleteAccountView
//
//  Created by Tatsuyuki Kobayashi on 2021/09/10.
//

import SwiftUI
import AuthenticationServices

struct DeleteAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DeleteAccountViewModel()
    @State private var isDeleteAlertPresented = false
    
    var body: some View {
        List {
            VStack(alignment: .center, spacing: 16) {
                Text("アカウントを削除すると、書籍やメモなど関連する全てのデータが失われます。失われたデータは復元することはできません。")
                
                if viewModel.isLinkedWithAppleId {
                    VStack(alignment: .center, spacing: 16) {
                        Divider()
                        
                        Text("アカウントを削除するには、あらかじめApple IDとの連携を解除する必要があります。")

                        Spacer() // required to show the text expectedly

                        Button {
                            Task {
                                await viewModel.onUnlinkWithAppleID()
                            }
                        } label: {
                            Text("連携を解除")
                                .foregroundColor(.alert)
                        }
                    }
                } else {
                    Button {
                        Task {
                            await viewModel.onDeleteAccount()
                        }
                    } label: {
                        Text("アカウントを削除")
                            .foregroundColor(.alert)
                    }
                }
            }
            .font(.medium)
            .foregroundColor(.textSecondary)
            .padding(.vertical, 16)
            .listSectionSeparator(.hidden)
            .buttonStyle(PlainButtonStyle())
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("アカウントを削除", displayMode: .inline)
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial:
                break
            case .loading:
                LoadingHUD.show()
            case .deleted:
                LoadingHUD.dismiss()
                dismiss()
            case .failed:
                LoadingHUD.dismiss()
                ErrorHUD.show(message: .deleteAccount)
            }
        }
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("アカウントを削除"),
                message: Text("アカウントを削除すると元に戻すことはできません。アカウントを削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("削除"), action: {
                    Task {
                        await viewModel.onDeleteAccount()
                    }
                })
            )
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}
