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
    @State private var isDeleteAlertPresented = false
    
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
                            }
                        }
                        if !viewModel.isLinkedAppleId {
                            Text("※ 連携すると、他のデバイスとデータを共有してご利用いただけます。")
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
                
                Section {
                    HStack {
                        Spacer()
                        Button {
                            isDeleteAlertPresented = true
                        } label: {
                            Text("アカウントを削除する")
                                .font(.medium)
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    .buttonStyle(PlainButtonStyle())
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
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("アカウントを削除"),
                message: Text("削除するとすべてのデータが失われてしまいます。アカウントを削除しますか？"),
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

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}
