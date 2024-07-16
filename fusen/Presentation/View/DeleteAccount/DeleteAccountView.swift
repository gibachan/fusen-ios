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
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Text("アカウントを削除すると、書籍やメモなど関連する全てのデータが失われます。失われたデータは復元することはできません。")

                Divider()

                if viewModel.isLinkedWithAppleId {
                    Text("Appleアカウントと連携している場合は、アカウント削除のために再認証が必要となります。")

                    Text("アカウントを削除しますか？")
                        .padding(.top, 16)

                    SignInWithAppleButton(
                        .signIn,
                        onRequest: viewModel.onSignInWithAppleRequest,
                        onCompletion: viewModel.onSignInWithAppleCompletion
                    ).signInWithAppleButtonStyle(.black)
                        .frame(width: 200, height: 32)
                } else if viewModel.isLinkedWithGoogle {
                    Text("Googleアカウントと連携している場合は、アカウント削除のために再認証が必要となります。")

                    Text("アカウントを削除しますか？")
                        .padding(.top, 16)

                    GoogleSignInButton { result in
                        viewModel.onSignInWithGoogle(result)
                    }
                    .frame(height: 36)
                } else {
                    Text("アカウントを削除しますか？")
                        .padding(.top, 16)

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
            .font(.small)
            .foregroundColor(.textPrimary)
            .padding(16)
            .listSectionSeparator(.hidden)
            .buttonStyle(PlainButtonStyle())
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("アカウントを削除", displayMode: .inline)
        .navigationBarItems(leading: CancelButton { dismiss() })
        .loading(viewModel.state == .loading)
        .task {
            await viewModel.onAppear()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial, .loading:
                break
            case .deleted:
                dismiss()
            case .failed:
                ErrorSnackbar.show(message: .deleteAccount)
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
