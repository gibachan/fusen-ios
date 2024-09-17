//
//  ViewExtension.swift
//  ViewExtension
//
//  Created by Tatsuyuki Kobayashi on 2021/08/31.
//

import SwiftUI

extension View {
    func backgroundColor(_ color: Color) -> some View {
        self.background(color)
    }

    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        background(NavigationLink(isActive: isActive, destination: destination, label: { EmptyView() }))
    }

    func debug(_ block: () -> Void) -> some View {
        block()
        return self
    }

    func centerHorizontally() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }

    func share(text: String) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first

        let activityItems = [text] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let viewController = window?.rootViewController
        viewController?.present(activityVC, animated: true)
    }
}
