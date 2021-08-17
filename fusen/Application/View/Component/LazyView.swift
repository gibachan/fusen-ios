//
//  LazyView.swift
//  LazyView
//
//  Created by Tatsuyuki Kobayashi on 2021/08/12.
//

import SwiftUI

struct LazyView<Content: View>: View {
    private let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
