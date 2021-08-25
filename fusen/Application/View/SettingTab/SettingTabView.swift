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
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            List {
                Section {
                    HStack {
                        Text("ID")
                            .font(.medium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text(viewModel.userId)
                            .font(.small)
                            .foregroundColor(.textPrimary)
                    }
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: viewModel.onSignInWithAppleRequest,
                        onCompletion: viewModel.onSignInWithAppleCompletion
                    ).signInWithAppleButtonStyle(.whiteOutline)
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
                        Text("バージョン")
                            .font(.medium)
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text(viewModel.version)
                            .font(.small)
                            .foregroundColor(.textPrimary)
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
            
            Divider() // FIXME: Find another way to show top edge of tabbar
        }
        .navigationBarTitle("設定")
        .onAppear {
            viewModel.onApper()
        }
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}
