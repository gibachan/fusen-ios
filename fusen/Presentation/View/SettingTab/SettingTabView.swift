//
//  SettingTabView.swift
//  SettingTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import AuthenticationServices
import SwiftUI

struct SettingTabView: View {
    @StateObject private var viewModel = SettingTabViewModel()
    @State private var alertType: AlertType?
    @State private var isDeleteAccountPresented = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            List {
                Section {
                    HStack {
                        Text("ID :")
                            .font(.medium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text(viewModel.userId)
                            .textSelection(.enabled)
                            .font(.small)
                            .foregroundColor(.textSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("アカウントを連携 :")
                            .font(.medium)
                            .foregroundColor(.textPrimary)
                        
                        VStack(alignment: .center) {
                            if viewModel.isLinkedAppleId {
                                Text("Apple IDと連携済み")
                                    .font(.small)
                                    .foregroundColor(.textSecondary)
                                    .padding(.vertical, 8)
                                    .onTapGesture {
                                        alertType = .unlinkWithApple
                                    }
                            } else {
                                SignInWithAppleButton(
                                    .signIn,
                                    onRequest: viewModel.onSignInWithAppleRequest,
                                    onCompletion: viewModel.onSignInWithAppleCompletion
                                ).signInWithAppleButtonStyle(.black)
                                    .frame(width: 240, height: 36)
                            }
                            if viewModel.isLinkedWithGoogle {
                                Text("Googleアカウントと連携済み")
                                    .font(.small)
                                    .foregroundColor(.textSecondary)
                                    .padding(.vertical, 8)
                                    .onTapGesture {
                                        alertType = .unlinkWithGoogle
                                    }
                            } else {
                                GoogleSignInButton { result in
                                    viewModel.onSignInWithGoogle(result)
                                }
                                .backgroundColor(.red)
                                .frame(width: 240, height: 36)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        Text("※ 連携すると、複数のデバイスとデータを共有してご利用いただけます。")
                            .font(.small)
                            .foregroundColor(.textSecondary)
                        
                        Spacer(minLength: 8)
                    }
                } header: {
                    SectionHeaderText("アカウント")
                }
                
                Section {
                    NavigationLink {
                        WebPageView(url: URL.term)
                            .navigationBarTitle("利用規約", displayMode: .inline)
                    } label: {
                        HStack {
                            Text("利用規約")
                                .font(.medium)
                                .foregroundColor(.textPrimary)
                        }
                    }
                    
                    NavigationLink {
                        WebPageView(url: URL.privacy)
                            .navigationBarTitle("プライバシーポリシー", displayMode: .inline)
                    } label: {
                        HStack {
                            Text("プライバシーポリシー")
                                .font(.medium)
                                .foregroundColor(.textPrimary)
                        }
                    }
                    
                    //                    NavigationLink {
                    //                        Text("Not implemented yet")
                    //                    } label: {
                    //                        HStack {
                    //                            Text("アプリを評価")
                    //                                .font(.medium)
                    //                                .foregroundColor(.textPrimary)
                    //                        }
                    //                    }
                    
                    HStack {
                        Text("バージョン :")
                            .font(.medium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text(viewModel.version)
                            .font(.small)
                            .foregroundColor(.textSecondary)
                    }
                }
#if DEBUG
                Section {
                    HStack {
                        Text("環境 :")
                            .font(.medium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        switch AppEnv.current {
                        case .development:
                            Text("development")
                                .font(.small)
                                .foregroundColor(.textSecondary)
                        case .staging:
                            Text("staging")
                                .font(.small)
                                .foregroundColor(.textSecondary)
                        case .production:
                            fatalError("Not supposed to be reached")
                        }
                    }
                    Button {
                        Task {
                            await viewModel.onResetUserActionHstory()
                        }
                    } label: {
                        Text("ユーザー行動履歴をリセット")
                    }
                    Button {
                        viewModel.onLogOut()
                    } label: {
                        Text("ログアウト")
                    }
                    Button {
                        isDeleteAccountPresented = true
                    } label: {
                        Text("アカウントを削除")
                            .foregroundColor(.alert)
                    }
                } header: {
                    SectionHeaderText("デバッグ")
                }
#endif
            }
            .listStyle(InsetGroupedListStyle())
            .buttonStyle(PlainButtonStyle())
        }
        .navigationBarTitle("設定")
        .onAppear {
            viewModel.onApper()
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .initial:
                break
            case .linkingWithApple, .linkingWithGoogle:
                LoadingHUD.show()
            case .succeeded:
                LoadingHUD.dismiss()
            case .failed:
                LoadingHUD.dismiss()
                ErrorHUD.show(message: .network)
            case .failedlinkingWithApple:
                LoadingHUD.dismiss()
                ErrorHUD.show(message: .linkWithAppleId)
            case .failedlinkingWithGoogle:
                LoadingHUD.dismiss()
                ErrorHUD.show(message: .linkWithAppleId)
            }
        }
        .alert(item: $alertType, content: { type in
            alert(of: type)
        })
        .sheet(isPresented: $isDeleteAccountPresented, onDismiss: {
            viewModel.onDeleteAccountFinished()
        }, content: {
            NavigationView {
                DeleteAccountView()
            }
        })
    }
}

private extension SettingTabView {
    enum AlertType: String, Identifiable {
        case unlinkWithApple
        case unlinkWithGoogle
        
        var id: String {
            self.rawValue
        }
    }
    
    func alert(of type: AlertType) -> Alert {
        switch type {
        case .unlinkWithApple:
            return Alert(
                title: Text("アカウント連携を解除"),
                message: Text("Apple IDとの連携を解除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("連携を解除"), action: {
                    Task {
                        await viewModel.onUnlinkWithAppleID()
                    }
                })
            )
        case .unlinkWithGoogle:
            return Alert(
                title: Text("アカウント連携を解除"),
                message: Text("Googleアカウントとの連携を解除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("連携を解除"), action: {
                    Task {
                        await viewModel.onUnlinkWithGoogle()
                    }
                })
            )
        }
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}
