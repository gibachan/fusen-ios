//
//  DeleteAccountView.swift
//  DeleteAccountView
//
//  Created by Tatsuyuki Kobayashi on 2021/09/10.
//

import AuthenticationServices
import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DeleteAccountViewModel()
    @State private var isDeleteAlertPresented = false
    
    var body: some View {
        List {
            VStack(alignment: .center, spacing: 16) {
                Text("アカウントを削除すると、書籍やメモなど関連する全てのデータが失われます。失われたデータは復元することはできません。")
                
                Text("アカウントを削除しますか？")
                    .padding(.top, 16)
                
                if viewModel.isLinkedWithAppleId {
                    Divider()
                    
                    Text("他のアカウントと連携している場合は、アカウント削除のために再認証が必要となります。")
                    
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: viewModel.onSignInWithAppleRequest,
                        onCompletion: viewModel.onSignInWithAppleCompletion
                    ).signInWithAppleButtonStyle(.black)
                        .frame(width: 200, height: 32)
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
        .navigationBarItems(leading: CancelButton { dismiss() })
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
