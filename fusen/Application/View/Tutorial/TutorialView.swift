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
    @State private var isErrorActive = false
    var body: some View {
        TabView {
            page1.tag(0)
            page2.tag(1)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .toast(text: "Unexpected error occured!", type: .error, isActive: $isErrorActive)
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
                isErrorActive = true
            }
        }
    }
}

extension TutorialView {
    private var page1: some View {
        VStack(spacing: 16) {
            Text("Tutorial 1")
            Spacer()
        }
        .padding()
    }
    
    private var page2: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                Text("Tutorial 2")
                
                SignInWithAppleButton(
                    .signIn,
                    onRequest: viewModel.onSignInWithAppleRequest,
                    onCompletion: viewModel.onSignInWithAppleCompletion
                ).signInWithAppleButtonStyle(.whiteOutline)
                    
                Button {
                    Task {
                        await viewModel.onSkip()
                    }
                } label: {
                    Text("スキップ")
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
