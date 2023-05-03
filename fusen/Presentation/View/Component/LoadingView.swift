//
//  LoadingView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2023/04/29.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
    }
}

struct Loading: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
            if isLoading {
                LoadingView()
            }
        }
    }
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        self.modifier(Loading(isLoading: isLoading))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello World 1")
                .backgroundColor(.backgroundLightGray)
                .frame(width: 200, height: 300)
                .loading(true)
            Text("Hello World 2")
                .backgroundColor(.backgroundLightGray)
                .frame(width: 200, height: 300)
                .loading(false)
        }
    }
}
