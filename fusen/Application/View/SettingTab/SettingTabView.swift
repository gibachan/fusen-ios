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
        NavigationView {
            ZStack(alignment: .bottomLeading) {
                List {
                    Section {
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: viewModel.onSignInWithAppleRequest,
                            onCompletion: viewModel.onSignInWithAppleCompletion
                        ).signInWithAppleButtonStyle(.whiteOutline)
                    } header: {
                        SectionHeaderText("デバッグ")
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
        }
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}
