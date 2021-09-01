//
//  TutorialView.swift
//  TutorialView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/14.
//

import SwiftUI
import AuthenticationServices

struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TutorialViewModel()
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 32) {
                    Text("ようこそ")
                        .font(.largeTitle.bold())
                        .foregroundColor(.textPrimary)
                        .padding(.top, 24)
                    HStack(alignment: .center, spacing: 16) {
                        Image.book
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 32, height: 40)
                            .foregroundColor(.active)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("書籍を登録")
                                .font(.small.bold())
                                .foregroundColor(.textPrimary)
                            Text("バーコードを読み取って簡単に書籍を登録できます。マニュアル登録も可能です。\n書籍はコレクションで分類して整理できます。")
                                .font(.small)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    HStack(alignment: .center, spacing: 16) {
                        Image.memo
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.active)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("メモを蓄積")
                                .font(.small.bold())
                                .foregroundColor(.textPrimary)
                            Text("本を読んで気づいたことを手軽にメモに残しましょう。本文をカメラで読み取って手軽に引用したり、残したメモを一覧で確認できます。")
                                .font(.small)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    HStack(alignment: .center, spacing: 16) {
                        Image.account
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.active)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("データを共有")
                                .font(.small.bold())
                                .foregroundColor(.textPrimary)
                            Text("Apple IDと連携することで、複数のデバイスとデータを共有してご利用いただけます。")
                                .font(.small)
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
            }
            Spacer()
            
            VStack(spacing: 16) {
                Button {
                    Task {
                        await viewModel.onSkip()
                    }
                } label: {
                    Text("ログインせずに続ける")
                }
                .foregroundColor(.textPrimary)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.textPrimary, lineWidth: 1)
                )

                SignInWithAppleButton(
                    .signIn,
                    onRequest: viewModel.onSignInWithAppleRequest,
                    onCompletion: viewModel.onSignInWithAppleCompletion
                ).signInWithAppleButtonStyle(.black)
                    .frame(height: 40)
                
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
        .padding(.horizontal, 32)
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
            }
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
