//
//  SettingTabView.swift
//  SettingTabView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI
import AuthenticationServices

struct SettingTabView: View {
    @StateObject private var viewModel = SettingTabViewModel()
    @State private var isUnlinkAlertPresented = false
    
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Apple IDと連携 :")
                                .font(.medium)
                                .foregroundColor(.textPrimary)
                            Spacer()
                            
                            if viewModel.isLinkedAppleId {
                                Text("連携済み")
                                    .font(.small)
                                    .foregroundColor(.textSecondary)
                                    .onTapGesture {
                                        isUnlinkAlertPresented = true
                                    }
                            }
                        }
                        if !viewModel.isLinkedAppleId {
                            Text("※ 連携すると、複数のデバイスとデータを共有してご利用いただけます。")
                                .font(.small)
                                .foregroundColor(.textSecondary)
                        
                            HStack {
                                Spacer()
                                SignInWithAppleButton(
                                    .signIn,
                                    onRequest: viewModel.onSignInWithAppleRequest,
                                    onCompletion: viewModel.onSignInWithAppleCompletion
                                ).signInWithAppleButtonStyle(.black)
                                    .frame(width: 200, height: 32)
                                Spacer()
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    SectionHeaderText("アカウント")
                }
                
                Section {
                    NavigationLink {
                        Text("Not implemented yet")
                    } label: {
                        HStack {
                            Text("アプリを評価")
                                .font(.medium)
                                .foregroundColor(.textPrimary)
                        }
                    }

                    NavigationLink {
                        Text("Not implemented yet")
                    } label: {
                        HStack {
                            Text("ライセンス")
                                .font(.medium)
                                .foregroundColor(.textPrimary)
                        }
                    }
                    
                    NavigationLink {
                        VStack(alignment: .center) {
                            Text("Supported by Rakuten Developers")
                                .font(.medium)
                                .foregroundColor(.textPrimary)
                            Spacer()
                        }
                        .navigationBarTitle("クレジット")
                    } label: {
                        HStack {
                            Text("クレジット")
                                .font(.medium)
                                .foregroundColor(.textPrimary)
                        }
                    }
                    
                    HStack {
                        Text("バージョン :")
                            .font(.medium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text(viewModel.version)
                            .font(.small)
                            .foregroundColor(.textSecondary)
                    }
                } header: {
                    SectionHeaderText("アプリ")
                }
#if DEBUG
                Section {
                    Button {
                        viewModel.logOut()
                    } label: {
                        Text("ログアウト")
                    }
                } header: {
                    SectionHeaderText("デバッグ")
                }
#endif
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle("設定")
        .onAppear {
            viewModel.onApper()
        }
        .alert(isPresented: $isUnlinkAlertPresented) {
            Alert(
                title: Text("アカウント連携を解除"),
                message: Text("Apple IDとの連携を解除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("連携を解除"), action: {
                    Task {
                        await viewModel.onUnlinkWithAppleID()
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
