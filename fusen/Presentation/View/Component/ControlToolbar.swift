//
//  ControlToolbar.swift
//  ControlToolbar
//
//  Created by Tatsuyuki Kobayashi on 2021/08/17.
//

import SwiftUI

struct ControlToolbar<L: View, R: View>: View {
    typealias Action = () -> Void
    private let leadingView: L
    private let trailingView: R

    init(
        @ViewBuilder leadingView: () -> L,
        @ViewBuilder trailingView: () -> R
    ) {
        self.leadingView = leadingView()
        self.trailingView = trailingView()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            leadingView
            Spacer()
            trailingView
        }
        .padding(.horizontal, 24)
        .frame(height: 48)
        .border(Color.backgroundGray, width: 0.5)
    }
}

struct TrailingControlToolbar<R: View>: View {
    typealias Action = () -> Void
    private let trailingView: R

    init(
        @ViewBuilder trailingView: () -> R
    ) {
        self.trailingView = trailingView()
    }
    
    var body: some View {
        ControlToolbar(
            leadingView: { EmptyView() },
            trailingView: { trailingView }
        )
    }
}

struct ControlToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ControlToolbar(leadingView: { EmptyView() }, trailingView: { EmptyView() })
    }
}
