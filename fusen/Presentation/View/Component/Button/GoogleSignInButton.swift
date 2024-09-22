//
//  GoogleSignInButton.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2021/10/17.
//

import Firebase
import FirebaseAuth
import GoogleSignIn
import SwiftUI

enum GoogleSignInError: Error {
    case missingPresenting
    case missingClientId
    case missingIdToken
    case canceled
    case unknown
}

struct GoogleSignInButton: View {
    let handler: (Result<AuthCredential, GoogleSignInError>) -> Void

    var body: some View {
        Button {
            signIn()
        } label: {
            HStack {
                Spacer()
                HStack {
                    Image.googleLogo
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .accessibility(label: Text("Sign in with Google"))
                    Spacer().frame(width: 8)
                    Text("Sign in with Google")
                        .font(.system(size: 14))
                        .bold()
                        .foregroundColor(.textGoogleSignIn)
                }
                Spacer()
            }
            .padding(.vertical, 8)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.border, lineWidth: 0.5)
            )
        }
    }

    private func signIn() {
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            handler(.failure(.missingPresenting))
            return
        }

        // FIXME: Set configuration at right place which might be at app launch.
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            handler(.failure(.missingClientId))
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC, completion: { signInResult, error in
            if let error = error {
                log.e(error.localizedDescription)
                if (error as NSError).code == -5 {
                    handler(.failure(.canceled))
                } else {
                    handler(.failure(.unknown))
                }
                return
            }

            guard let result = signInResult,
                  let idToken = result.user.idToken?.tokenString else {
                handler(.failure(.missingIdToken))
                return
            }
            let accessToken = result.user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )
            handler(.success(credential))
        })
    }
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton { _ in }
    }
}
